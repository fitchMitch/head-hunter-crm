module ComactionsHelper
  def idtype(ev)
    if ev.action_type == Comaction::CLIENT_TYPE
      label_type = 'label-danger small_label '
      letter = "C"
    elsif ev.action_type == Comaction::PROSPECTION_TYPE
      label_type = 'label-info small_label '
      letter = "J"
    else
      label_type = ''
      letter = ''
    end
    res = '<span class="label label-mini ' + label_type +'">' + letter + '</span>'
    res.html_safe
  end

  def button_filters( cal )
    r=''
    Comaction::STATUSES.each { |status|
      if cal.to_i == 1
        r += link_to   status ,comactions_path(:filter => Comaction::STATUS_RELATED[status],:query => 'calendar_view'), class: "btn btn-primary"
      else
        r += link_to   status ,comactions_path(:filter =>Comaction::STATUS_RELATED[status],:query => 'table_view'), class: "btn btn-primary"
      end
    }
    r.html_safe
  end
end
