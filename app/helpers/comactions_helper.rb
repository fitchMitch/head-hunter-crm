module ComactionsHelper
  def idtype(ev)
    if ev.action_type == Comaction::CLIENT_TYPE
      label_type = 'label-danger'
      letter = 'C'
    elsif ev.action_type == Comaction::PROSPECTION_TYPE
      label_type = 'label-info'
      letter = "J"
    else
      label_type = ''
      letter = ''
    end
    res = '<span class="label label-mini ' + label_type +'">' + letter + '</span>'
    res.html_safe
  end
end
