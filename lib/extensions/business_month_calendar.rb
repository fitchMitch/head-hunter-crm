# ---------- BusinessMonthCalendar ------------------------------
class SimpleCalendar::BusinessMonthCalendar < SimpleCalendar::Calendar
  private
    def url_for_next_view
      @params.merge(start_date_param => to_next_month(date_range.last))
    end
    def url_for_previous_view
      @params.merge(start_date_param => to_previous_month(date_range.first))
    end

    def date_range
      r = []
      d1 = start_date.beginning_of_month.beginning_of_week
      d1 += 7 if d1.mon === (d1 + 4.days).mon && d1.day > d1.end_of_month.day - 6

      (0..5).to_a.each  { |i|
        beginning = d1 + (i * 7).days
        ending = beginning + 4.days
        r += (beginning..ending).to_a
      }
      r & (start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week).to_a
    end

    def to_next_month (d)
      d.day > d.end_of_month.day - 6 ? d.next_month : d
    end

    def to_previous_month (d)
      d.day > d.end_of_month.day - 6 ? d : d.prev_month
    end
end
