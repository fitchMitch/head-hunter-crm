class ComactionMailer < ApplicationMailer
    def make_ical_appointment(comaction, email)
        ical = Icalendar::Calendar.new
        ical.timezone.tzid = 'Europe/Paris'

        e = Icalendar::Event.new
        e.dtstart = comaction.start_time
        e.dtend = comaction.end_time
        e.organizer = %W(mailto:#{email})
        e.summary  = "Meeting avec #{ comaction.person.full_name }"
        e.description = "Mission : #{ comaction.mission.name } pour la société #{ comaction.mission.company.company_name }"
        # e.uid = comaction.id
        file_name = comaction.person.firstname  + '\.ics'

        ical.add_event(e)
        # ical.publish

        mail.attachments[file_name] = { mime_type: 'application/ics', content: ical.to_ical }
    end

    def one_event_saving(comaction, user, creation=true)
      @comaction = comaction
      subject = creation ? 'RdV ' : 'Mise à jour du RdV '
      make_ical_appointment(comaction, user.email)
      subj = subject + "#{I18n.t("brand")} " + comaction.person.full_name
      mail to: user.email, subject: subj
    end
end
