class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_EMAIL', nil)
  layout 'mailer'
end
