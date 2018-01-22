module ComactionsHelper

  def idtype(ev)
    # ev is a a compaction, ev.action_type is a symbol
    letter = label_type = ' '
    if ev.client_type?
      label_type = 'label-primary small_label '
      letter = 'C'
    elsif ev.apply_type?
      label_type = 'label-info small_label '
      letter = 'F'
    elsif ev.apply_customer_type?
      label_type = 'label-danger small_label '
      letter = 'R'
    elsif ev.exploration_type?
      label_type = 'label-default small_label '
      letter = 'E'
    end
    "<p class='label label-mini #{label_type}'> #{letter} </p>".html_safe
  end

  def background_style(ev)
    # ev as a comaction
    type_style = {
      client_type: 'client-appointment',
      apply_type: 'applier-appointment',
      apply_customer_type: 'applier-client-appointment',
      exploration_type: 'exploration-appointment',
      other_type: 'none'
    }
    used_style = type_style[ev.action_type.to_sym]
    style = "status-frame #{used_style}"
  end
  def t_com_status(k)
    k = :opportunity if k == '' || k == ' '
    I18n.t("comaction.status.#{k}")
  end

  def t_com_ac_type(k)
    I18n.t("comaction.action_type.#{k}")
  end

  def status_collection
    colle=[]
    Comaction::statuses.each do |k, _|
      colle << [t_com_status(k),k]
    end
    colle
  end

  def type_collection
    colle = []
     Comaction::action_types.each do |k, _|
      colle << [t_com_ac_type(k), k]
    end
    colle
  end

  def illustrate(periods)
    logger.debug('fatal illustration') unless periods.instance_of?(Array)
    t = true
    periods.map{|z| t &&= z.instance_of?(EventSlot) }
    return 'fatal illustration2' unless t

    block = [].fill("<span class='busy'></span>", 0..47) #half_hours
    #
    periods.each do |per|
      per.to_half_hours_range.each do |n|
        items = []
        items << "<span class='not-busy' data-block='#{n}-#{per.time_frame.min.day}"
        items << "-#{per.time_frame.min.month}-#{per.time_frame.min.year}' "
        items << "data-toggle='tooltip' data-placement='left' title='#{n/2}h'></span>"

        block[n] = items.join('')
      end
    end
    block.slice(Comaction::WORK_HOURS.first * 2 .. Comaction::WORK_HOURS.last * 2 - 1).join('').html_safe
  end

  def getComactionTitle(c)
    "<strong>#{c.person.full_name}</strong><br>\
    #{t_com_ac_type(c.action_type)} [#{t_com_status(c.status)}] "
  end

  def getComactionDetails(c)
    "<i class='fa fa-bookmark-o '></i> : \
    [#{t_mis_status c.mission.status}] #{c.mission.name} <br>\
    <i class='fa fa-building-o '></i> : \
    <strong>#{c.mission.company.company_name}</strong>"
  end
end
