module MissionsHelper
  def special_label(mission)
    t = ''
    if(mission.is_done)
      t = '<h3><strong> <i class="fa fa-gavel" aria-hidden="true"></i> </strong> ' + mission.status  + '</h3>'
    elsif (mission.is_signed)
      t = '<h3><strong> <i class="fa fa-handshake-o" aria-hidden="true"></i> </strong> ' + mission.status  + '</h3>'
    end
    t.html_safe
  end

end
