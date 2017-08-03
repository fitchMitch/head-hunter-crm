class EventPeriod
  require 'date'
  attr_accessor :start_datetime, :end_datetime, :range, :min_duration

  def initialize(starttime, endtime)
    raise unless starttime.is_a?(DateTime) && endtime.is_a?(DateTime) && endtime < starttime
    @start_datetime = starttime
    @end_datetime = endtime
    @range  = (starttime .. endtime)
    @min_duration =0
    @min_duration = update_duration()
  end

  def update_duration
    t =  24 * 60 * days_overlap()
    t += (self.end_datetime.seconds_since_midnight - self.start_datetime.seconds_since_midnight) /60
    t.round
  end

  def get_hours_duration
    min_left = self.min_duration % 60
    ((self.min_duration - min_left) / 60).round
  end

  def overlaps?(o_period)
    #  return nil unless o_period.is_a?(Period)
    #  c1 =  self.start_datetime <= o.start_datetime
    #  c2 = self.end_datetime >= o.end_datetime
    #  c3 = self.end_datetime >= o.start_datetime && self.end_datetime <= o.end_datetime
    #  c4 =  self.start_datetime >= o.start_datetime && self.start_datetime <= o.end_datetime
    #  # overlap
    #  (c1 && c2) || (c1 && c3) || (c4 && c2) || (c4 && c3)
    self.range.overlaps?(o_period.range)
  end

  def overlaps_two_days?
    (self.start_datetime.beginning_of_day - self.end_datetime.beginning_of_day).round > 0
  end

  def days_overlap
    (self.end_datetime - self.start_datetime).round
  end

  def update_begin (bego)
    return  unless bego.is_a?(DateTime) || bego > self.end_datetime
    self.start_datetime = bego
    self.range = (bego .. self.end_datetime)
    update_duration()
  end

  def update_end (endo)
    return  unless endo.is_a?(DateTime) || endo < self.start_datetime
    self.end_datetime = endo
    self.range = (self.start_datetime .. endo)
    update_duration()
  end

  def days_split
    r = []
    s = self.start_datetime
    e = self.end_datetime
    if self.overlaps_two_days?
      r << self
    else
      (0 .. self.days_overlap).to_a.each { |diff|
        r << EventPeriod.new(s.beginning_of_day.since(diff.days), s.end_of_day.since(diff.days))
      }
    end
    r.first.update_begin(s)
    r.last.update_end(e)
  end

  def days_work(hour_begin,hour_end)
    return nil if hour_begin > hour_end
    r = []
    self.days_split.each do |da|
      da.update_begin(da.beginning_of_day.since(hour_begin.hours)) if  da.start_datetime < da.beginning_of_day.since(hour_begin.hours)
      da.update_end(da.beginning_of_day.since(hour_end.hours)) if  da.end_datetime > da.beginning_of_day.since(hour_end.hours)
      r << da
    end
    r
  end

  def split_in_hours
    return nil if self.overlaps_two_days? || self.min_duration < 91
    r = []
    start_hour, start_min = self.start_datetime.hour , self.start_datetime.min

    if start_min = start_min > 0 && start_min <= 30
      start_min = 30
    else
      start_min = 0
      start_hour += 1
    end
    (self.get_hours_duration).to_a.each do |h|
      r << EventPeriod.new(self.beginning_of_day.since((start_hour+h).hours).since(start_min.minutes), self.beginning_of_day.since((start_hour+h+1).hours).since(start_min.minutes))
    end
  end
end
