module MissionsHelper

  def special_label(mission)
    # <div class="<%= latelyness mission %>">
    supp=''
    if (mission.is_done)
      supp = "<i class='fa fa-gavel colorMe' aria-hidden='true'></i>"
    elsif (mission.signed)
      supp = "<i class='fa fa-handshake-o colorMe' aria-hidden='true'></i>"
    end
    "<h3> #{t_mis_status mission.status} <strong> #{supp}</strong></h3>".html_safe
  end

  def latelyness (mission)
    st = 'row '
    if mission.is_done
      st += 'mission_done'
    elsif mission.whished_start_date < Time.zone.now
      st += 'late'
    end
  end

  def search_checkboxes_names (name,i)
    (name + i.to_s).to_sym
  end

  def t_mis_status (k)
    I18n.t("mission.status.#{k}")
  end

  def mission_status_collection
    colle=[]
    Mission::statuses.each do |k,v|
      colle << [t_mis_status(k),k]
    end
    colle
  end

  def button_filters_missions(selected, css)
    statuses = [["",""]]
    Mission::statuses.each do |k,v|
      statuses << [t_mis_status(k),v]
    end
    opt = options_for_select(statuses, selected)
    "<select class='#{css}' id='mission_status' > #{opt}</select>".html_safe
  end

  def missions_options(sel)
    opt = mission_status_collection + [" "]
    options_for_select(opt,[sel,sel])
  end

end
