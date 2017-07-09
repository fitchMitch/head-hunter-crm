require_relative 'boot'

# require File.expand_path('../boot', __FILE__)
# ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JjFloApp
  class Application < Rails::Application
    #locale
    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    I18n.default_locale = :fr
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
