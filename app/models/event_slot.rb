# class WorkingSlot < EventSlot
#   include ActiveModel::Model
#
#   validate :not_out_of_bonds
#
#   def initialize
#     super
#   end
#
#   def not_out_of_bonds
#     if start_period < hours_work.first || end_period > hours_work.lastname
#       errors.add (:start_period, "out of bond action")
#     end
#   end
#
#   def filter_out_of_bonds
#
#
#   end
#
# end

class EventSlot
  include ActiveModel::Model

  attr_accessor :start_period, :end_period, :range, :min_duration

  def initialize(attributes)
    raise "start and endtime do not suit" unless attributes[:start_period].is_a?(DateTime) && attributes[:end_period].is_a?(DateTime) && attributes[:end_period] >= attributes[:start_period]
    super
    @range = (attributes[:start_period]..attributes[:end_period])
    update_duration
  end

  def get_hours_duration
    min_left = self.min_duration % 60
    ((self.min_duration - min_left) / 60).round
  end

  def overlaps?(o_period)
    #  return nil unless o_period.is_a?(Period)
    #  c1 =  self.start_period <= o.start_period
    #  c2 = self.end_period >= o.end_period
    #  c3 = self.end_period >= o.start_period && self.end_period <= o.end_period
    #  c4 =  self.start_period >= o.start_period && self.start_period <= o.end_period
    #  # overlap
    #  (c1 && c2) || (c1 && c3) || (c4 && c2) || (c4 && c3)
    range.overlaps?(o_period.range)
  end

  def hours_work(hour_begin, hour_end)
    return nil if hour_begin > hour_end
    r = []
    working_days_split.each do |da|
      beg_offset = da.start_period.beginning_of_day.advance(hours: hour_begin)
      end_offset = da.end_period.beginning_of_day.advance(hours: hour_end)
      da.update_begin(beg_offset) if da.start_period < beg_offset
      da.update_end(end_offset) if  da.end_period > end_offset
      r << da
    end
    r
  end

  def working_days_split
    r = []
    s = self.start_period
    e = self.end_period
    if overlaps_two_days?
      (0..days_overlap).to_a.each do |diff|
        day_offset = s.beginning_of_day.advance(days: diff)
        offset_s = day_offset
        offset_e = s.end_of_day.advance(days: diff)
        r << EventSlot.new(
          :start_period => offset_s,
          :end_period => offset_e
          ) unless day_offset.sunday == day_offset
      end
    else
      r << self
    end
    return nil if r.empty?
    r.first.update_begin(s)
    r.last.update_end(e)
    r
  end

  def out_from_intersect(rdv_period)
    return "not_a_EventSlot" unless rdv_period.is_a?(EventSlot)
    return "two_days_error" if self.overlaps_two_days? || rdv_period.overlaps_two_days?
    r = []
    ends = {:start_period => rdv_period.end_period, :end_period => self.end_period }
    starts = { :start_period => self.start_period, :end_period => rdv_period.start_period }
    #comactions appointments cannot start or finish after working_hours
    if self.overlaps? rdv_period
      r << EventSlot.new( starts) unless self.start_period == rdv_period.start_period
      r << EventSlot.new( ends ) unless self.end_period == rdv_period.end_period
      self.destroy
    else
      r << self
    end
  end

  def update_begin(bego)
    return unless bego.is_a?(DateTime) || bego > self.end_period
    self.start_period = bego
    self.range = (bego..self.end_period)
    update_duration
  end

  def update_end(endo)
    return  unless endo.is_a?(DateTime) || endo < self.start_period
    self.end_period = endo
    self.range = (self.start_period..endo)
    update_duration
  end
  # =================
  private
  # =================
    def update_duration
      self.min_duration = ((self.end_period - self.start_period) * 24 * 60).to_i.round
    end

    def overlaps_two_days?
      (self.end_period.beginning_of_day - self.start_period.beginning_of_day).to_i.round > 0
    end

    def days_overlap
      (self.end_period - self.start_period).round
    end



    def split_in_hours
      return "extremes_hit" if overlaps_two_days? || min_duration < 91
      r = []
      starter = self.round_hours
      start_hour, start_min = starter[:hours] , starter[:min]
      (0..self.get_hours_duration).to_a.each do |h|
        r << EventSlot.new(
          :start_period => self.start_period.beginning_of_day.advance(hours: (start_hour + h), minutes: start_min),
          :end_period => self.end_period.beginning_of_day.advance(hours: (start_hour + h + 1), minutes: start_min)
          )
      end
      r
    end

    def round_hours
      start_hour = self.start_period.hour
      start_min = self.start_period.min

      if start_min = start_min > 0 && start_min <= 30
        start_min = 30
      else
        start_min = 0
        start_hour += 1
      end
      {min: start_min, hours: start_hour}
    end

    def is_greater?(other)
      return "not_a_EventSlot" unless other.is_a?(EventSlot)
      c1 = self.start_period <  other.start_period && other.end_period <= self.end_period
      c2 = self.start_period <=  other.start_period && other.end_period < self.end_period
      c1 || c2
    end

end
