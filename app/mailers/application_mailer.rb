class ApplicationMailer < ActionMailer::Base
  # default from: "no-reply@#{I18n.t("brand")}.fr'
  default from: 'no-reply@etienneweil.fr'
  layout 'mailer'
end
