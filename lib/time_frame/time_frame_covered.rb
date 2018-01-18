# Encoding: utf-8
class TimeFrame
  # Getting the covering time frame from a bunch of time_frame's.
  class CoveredFrame
    def initialize(time_frames)
      @time_frames = time_frames.reject(&:empty?)
    end

    def frame
      return EMPTY unless @time_frames.any?
      min = @time_frames.min_by(&:min).min
      max = @time_frames.max_by(&:max).max
      TimeFrame.new(min: min, max: max)
    end
  end
end
