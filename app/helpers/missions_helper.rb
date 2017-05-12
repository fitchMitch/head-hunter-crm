module MissionsHelper
  def special_label(mission)
    t = ''
    if (mission.is_done)
      t = "<h3><strong> <i class='fa fa-gavel colorMe' aria-hidden='true'></i> </strong> "
        + mission.status + '</h3>'
    elsif (mission.signed)
      t = "<h3><strong> <i class='fa fa-handshake-o colorMe' aria-hidden='true'></i> </strong> "
        + mission.status  + '</h3>'
    end
    t.html_safe
  end

  def latelyness (mission)
    st = ' row '
    if mission.is_done
      st += 'mission_done'
    elsif mission.whished_start_date < Time.zone.now
      st += 'late'
    end
  end

end
