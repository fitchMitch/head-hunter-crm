require_relative 'boot'

# require File.expand_path('../boot', __FILE__)
# ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'

# EWE : remove the next two lines when ruby version is 2.3 or higher
# Purpose of these is to speed up init time on my local machine
# require 'securerandom'
# SecureRandom.hex(16)

require 'rails/all'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JjFloApp
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/lib"
    #locale
    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    I18n.default_locale = :fr
    config.time_zone = "Paris"
    config.beginning_of_week = :monday
    config.mail_wanted = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.logger = Logger.new(STDOUT)

    config.generators do |g|
      g.factory_girl false
    end
    config.generators do |g|
      g.test_framework :minitest, spec: true
    end
  end
end
