module MissionsHelper

  def special_label(mission)
    # <div class="<%= latelyness mission %>">
    supp=''
    if (mission.is_done)
      supp = "<i class='fa fa-gavel colorMe' aria-hidden='true'></i>"
    elsif (mission.signed)
      supp = "<i class='fa fa-handshake-o colorMe' aria-hidden='true'></i>"
    end
    "<h3> #{mission.status} <strong> #{supp}</strong></h3>".html_safe
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

end
