module ComactionsHelper
  def idtype(ev)
    letter = label_type = ''
    if ev.action_type == Comaction::CLIENT_TYPE
      label_type = 'label-primary small_label '
      letter = 'C'
    elsif ev.action_type == Comaction::APPLY_TYPE
      label_type = 'label-info small_label '
      letter = 'F'
    elsif ev.action_type == Comaction::APPLY_CUSTOMER_TYPE
      label_type = 'label-danger small_label '
      letter = 'R'
    elsif ev.action_type == Comaction::EXPLORATION_TYPE
      label_type = 'label-default small_label '
      letter = 'E'
    end
    "<p class='label label-mini #{label_type}'> #{letter} </p>".html_safe
  end

  def background_style (ev)
    style = "status-frame "
    style +=  case ev.action_type.to_s
      when Comaction::CLIENT_TYPE then "client-appointment"
      when Comaction::APPLY_TYPE then "applier-appointment"
      when Comaction::APPLY_CUSTOMER_TYPE then "applier-client-appointment"
      when Comaction::EXPLORATION_TYPE then "exploration-appointment"
      else ""
    end
  end

  def illustrate(periods)
    logger.debug("fatal illustration") unless periods.instance_of?(Array)
    t = true
    periods.map{|z| t &&= z.instance_of?(EventSlot) }
    return "fatal illustration2" unless t

    block = []
    block = block.fill("<span class='busy'></span>", 0..47) #half_hours
    #
    periods.each do |per|
      per.to_half_hours_range.each do |n|
        block[n] = "<span class='not-busy' data-block='#{n}-#{per.start_period.day}-#{per.start_period.month}-#{per.start_period.year}' data-toggle='tooltip' data-placement='left' title='#{n/2}h'></span>"
      end
    end
    block.slice(Comaction::WORK_HOURS.first*2..Comaction::WORK_HOURS.last*2-1).join("").html_safe
  end

  def getComactionTitle(c)
    "<strong>#{c.person.full_name}</strong><br>#{c.action_type} [#{c.status}] "
  end

  def getComactionDetails(c)
    "<i class='fa fa-bookmark-o '></i> : [#{c.mission.status}] #{c.mission.name} <br><i class='fa fa-building-o '></i> : <strong>#{c.mission.company.company_name}</strong>"
  end

  def button_filters(cal,last_val)
    statuses = [["",""]] + Comaction::STATUSES.each {|st| [st,Comaction::STATUS_RELATED[st].to_s] }
    opt = options_for_select(statuses,last_val)
    s = "<select class='form-control input-sm filter' id='mission_status'> #{opt}</select>".html_safe
  end
end
