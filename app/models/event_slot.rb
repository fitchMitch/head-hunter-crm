class EventSlot
  attr_accessor :time_frame

  def initialize(attributes)
    att = check_attributes(attributes)
    Rails.logger.warn ( "attributes is #{attributes}")
    self.time_frame = if att[:duration] == 0
      TimeFrame.new(min: att[:min], max: att[:max])
    else
      TimeFrame.new(min: att[:min], duration: att[:duration])
    end
  end

  def check_attributes(attri)
    min = attri.fetch(:min, 0)
    max = attri.fetch(:max, 0)
    duration = attri.fetch(:duration, 0)

    # if both max and duration are given, max is a priority
    raise 'minimum is badly initialized' if !min.is_a?(Time) || min == 0
    raise 'maximum is badly initialized' unless max.is_a?(Time) || max == 0
    duration = 0 if max != 0
    raise 'missing parameters max or duration' if max == 0 && duration == 0
    Rails.logger.warn ( "min is #{min} , max is #{max} and duration is #{duration}")
    { min: min, max: max, duration: duration }
  end

  def descro(text = [])
    text << "De #{time_frame.min.strftime('%d')}"
    text << I18n.t(time_frame.min.strftime('%B').to_s)
    text << time_frame.min.strftime('%B %H:%M').to_s
    text << "à #{time_frame.max.strftime('%H:%M')}"
    text.join(' ')
  end

  def do_union(new_min, new_max)
    timeframes = [time_frame, TimeFrame.new(min: new_min, max: new_max)]
    TimeFrame.union(timeframes).first
  end

  def extend_to_day_start #start at the first hour
    new_min = time_frame.min.beginning_of_day
    new_max = time_frame.min
    timeframe = do_union(new_min, new_max)
  end

  def extend_to_midnight # end at midnight
    new_min = time_frame.max
    new_max = time_frame.max.end_of_day
    timeframe = do_union(new_min, new_max)
  end

  def crop_after(new_max)
    excluding = TimeFrame.new(min: new_max, duration: 100.years)
    self.time_frame = time_frame.without(excluding).first
  end

  def crop_before(new_min)
    excluding = TimeFrame.new(min: new_min - 100.years, duration: 100.years)
    self.time_frame = time_frame.without(excluding).first
  end

  def day_slices
    # extend_to_square_days
    self.time_frame = extend_to_day_start
    self.time_frame = extend_to_midnight
    # slice_days is a TimeFrame array
    secs_in_a_day = 60 * 60 * 24
    slice_days = time_frame.split_by_interval(secs_in_a_day)
    event_slots = EventSlot.time_frames_to_array(slice_days)
  end

  def slicing_days
    start, ending = time_frame.min, time_frame.max
    event_slots = EventSlot.adjust_extremities(day_slices, start, ending)
  end

  def week_end_filter
    d = day_slices.delete_if { |es| es.time_frame.min.on_weekday? }
    EventSlot.to_time_frames(d)
  end

  def out_scheduled_filter
    now = Time.current
    tf_to_exclude = []
    days  = slicing_days.each { |es|
      day_start = es.time_frame.min.beginning_of_day
      new_max1 = day_start.advance(hours: Comaction::WORK_HOURS.first)
      tf_to_exclude << TimeFrame.new(min: day_start, max: new_max1)

      new_min2 = day_start.advance(hours: Comaction::WORK_HOURS.last)
      new_max2 = es.time_frame.min.end_of_day
      tf_to_exclude << TimeFrame.new(min: new_min2, max: new_max2)
    }
    tf_to_exclude << TimeFrame.new(min: now - 100.years, max: now)
  end

  def dash_it(next_comactions)
    # free_zone_days is ordered by design
    # so is next_comactions
    # Purpose : exclude for free_zone
    #    next_comactions
    #    non_working_schedules (including week-ends)
    time_frames_to_exclude = week_end_filter
    time_frames_to_exclude += out_scheduled_filter
    time_frames_to_exclude += EventSlot.to_time_frames(next_comactions)

    EventSlot.time_frames_to_array(time_frame.without(*time_frames_to_exclude))
  end

  def to_half_hours_range
    h_start= self.time_frame.min.hour * 2
    h_start += 1 if self.time_frame.min.min >= 30
    h_finish= self.time_frame.max.hour * 2 - 1
    h_finish += 1 if self.time_frame.max.min >= 30
    (h_start .. h_finish)
  end

  class << self
    def adjust_extremities(event_slots, start, ending)
      event_slots.first.crop_before(start)
      event_slots.last.crop_after(ending)
      event_slots
    end

    def time_frames_to_array(timeframes)
      arr = []
      timeframes.each do |tf|
        arr << EventSlot.new(min: tf.min, duration: tf.duration)
      end
      arr
    end

    def to_time_frames(event_slots)
      arr = []
      event_slots.each do |es|
        arr << TimeFrame.new(min: es.time_frame.min, duration: es.time_frame.duration)
      end
      arr
    end

    def sort_periods(arr)
      arr.group_by { |es| I18n.t(es.time_frame.min.strftime('%A')) + es.time_frame.min.strftime(' %d') }
    end
  end
  # =================
  private
  # =================
end
