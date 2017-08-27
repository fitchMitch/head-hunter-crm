class EventSlot
  include ActiveModel::Model

  attr_accessor :start_period, :end_period, :min_duration

  def initialize(attributes)
    raise "start and endtime do not suit" unless attributes[:start_period].is_a?(DateTime) && attributes[:end_period].is_a?(DateTime) && attributes[:end_period] >= attributes[:start_period]
    super
    update_duration
  end

  def descro
    "De  #{self.start_period.strftime('%H:%M')} à #{self.end_period.strftime('%H:%M')}"
  end

  def get_hours_duration
    min_left = self.min_duration % 60
    ((self.min_duration - min_left) / 60).round
  end

  def overlaps?(o_period)
    return nil unless o_period.is_a?(EventSlot)
    (self.start_period..self.end_period).overlaps?(o_period.start_period..o_period.end_period)
  end

  def working_days_split
    #split days and does Eventslots out of them, except sundays
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
          ) unless day_offset.wday == 0 #sunday
      end
    else
      r << self unless  day_offset.wday == 0 #sunday
    end
    return nil if r.empty?
    r
  end

  def too_short
    self.min_duration < Comaction::SHORTEST_MEETING_TIME
  end
  def starts_too_late
    self.start_period.hour >= (Comaction::WORK_HOURS.last.to_i - 1)
  end

  def out_from_intersect(rdv_period)
    #use : self is a free zone, rdv_period is an appointment
    return "not_a_EventSlot" unless rdv_period.is_a?(EventSlot)
    return "two_days_error #{self.descro} max:1440"  if self.overlaps_two_days? || rdv_period.overlaps_two_days?
    r = []
    self_start_before = self.start_period <= rdv_period.start_period
    self_end_after = rdv_period.end_period <= self.end_period
    # ---------------------
    if self.overlaps? rdv_period
      if self_start_before
        starts = { :start_period => self.start_period, :end_period => rdv_period.start_period }
        r << EventSlot.new( starts )
      end
      if self_end_after
        ends = {:start_period => rdv_period.end_period, :end_period => self.end_period }
        r << EventSlot.new( ends )
      end
    else
      r << self
    end
    r
  end

  def to_half_hours_range
    h_start= self.start_period.hour * 2
    h_start += 1 if self.start_period.minute >= 30
    h_finish= self.end_period.hour * 2 - 1
    h_finish += 1 if self.end_period.minute >= 30
    (h_start.. h_finish)
  end

  class << self
    def dash_it(freeZone_days, next_comactions)
      d = DateTime.current
      unfinished = true
      messages = []
      while unfinished
        unfinished = false
        next_comactions.each do |app|
          unless  app.start_time.nil? || app.end_time.nil? || app.end_time < d
            es_app = EventSlot.new({start_period: tdt(app.start_time), end_period: error_margin(app)})
            freeZone_days.each do
              ghost_day_free_zone = freeZone_days.shift
              next if ghost_day_free_zone.from_now_on == nil
              intersect = ghost_day_free_zone.out_from_intersect(es_app)
              unfinished = true if intersect.length > 1

              freeZone_days += intersect #unless intersect == nil || intersect.empty? || intersect.instance_of?(String)
              messages +=  intersect if intersect.instance_of?(String)
            end
          end
        end
      end
      {messages: messages, freeZone_days: freeZone_days}
    end
    def error_margin(app)
      # tdt (app.end_time.advance(minutes: 0))
      tdt (app.end_time)
    end

    def tdt (t)
      DateTime.parse(t.to_s)
    end

    def sharpen (arr)
      return nil unless arr.is_a?(Array)
      arr = arr
        .map { |fz| fz.set_to_office_hours}
        .map { |fz| fz.from_now_on}.compact
        .select do |fz|
          !fz.too_short
        end
      arr = arr.sort { |a,b| a.start_period <=> b.start_period }
      arr
    end

    def sort_periods(arr)
      arr.group_by {|es| I18n.t(es.start_period.strftime('%A')) + es.start_period.strftime(' %d')}
    end
  end
  # ---------------------

  # def split_in_hours
  #   return "extremes_hit" if overlaps_two_days?
  #   return [self] if self.min_duration < 60
  #   r = []
  #   starter = self.round_hours
  #   start_hour, start_min = starter[:hours] , starter[:min]
  #   (0..self.get_hours_duration).to_a.each do |h|
  #     r << EventSlot.new(
  #       :start_period => self.start_period.beginning_of_day.advance(hours: (start_hour + h), minutes: start_min),
  #       :end_period => self.end_period.beginning_of_day.advance(hours: (start_hour + h + 1), minutes: start_min)
  #       )
  #   end
  #   r
  # end

  def from_now_on
    now = DateTime.current
    return nil if self.end_period < now
    self.update_begin(now) if now > self.start_period
    self
  end

  def set_to_office_hours
    self.update_begin(start_period.change(hour: Comaction::WORK_HOURS.first)) if start_period.hour < Comaction::WORK_HOURS.first
    self.update_end  (  end_period.change(hour: Comaction::WORK_HOURS.last))  if end_period.hour   > Comaction::WORK_HOURS.last
    self
  end

  def update_begin(bego)
    return unless bego.is_a?(DateTime) || bego > self.end_period
    self.start_period = bego
    update_duration
  end

  def update_end(endo)
    return  unless endo.is_a?(DateTime) || endo < self.start_period
    self.end_period = endo
    update_duration
  end

  # def round_hours
  #   start_hour = self.start_period.hour
  #   start_min = self.start_period.min
  #
  #   if start_min == 0
  #   elsif start_min = start_min > 0 && start_min <= 30
  #     start_min = 30
  #   else
  #     start_min = 0
  #     start_hour += 1
  #   end
  #   start_hour -= 1  if start_hour == Comaction::WORK_HOURS.last
  #   {min: start_min, hours: start_hour}
  # end

  def overlaps_two_days?
    (self.end_period.beginning_of_day - self.start_period.beginning_of_day).to_i.round > 0
  end
  # =================
  private
  # =================
    def update_duration
      self.min_duration = ((self.end_period - self.start_period) * 24 * 60).to_i.round
    end

    def days_overlap
      (self.end_period - self.start_period).round
    end

end
