class TimeFrame
  # This class tells the active_record predicate builder how to handle
  # time_frame classes when passed into a where-clause
  class PredicateBuilderHandler
    def call(column, time_frame)
      column.in(time_frame.min..time_frame.max)
    end
  end
end
# new version ? EWE found this :
 # https://github.com/rails/rails/blob/92703a9ea5d8b96f30e0b706b801c9185ef14f0e/activerecord/lib/active_record/relation/predicate_builder.rb#L60
# ActiveRecord::PredicateBuilder.new("users").register_handler(MyCustomDateRange, handler)
ActiveRecord::PredicateBuilder.new("time_frames").register_handler(
  TimeFrame, TimeFrame::PredicateBuilderHandler.new
)
