class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@#{I18n.t("brand")}.fr"
  layout 'mailer'
end
