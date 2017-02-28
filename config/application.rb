require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JjFloApp
  class Application < Rails::Application
    I18n.default_locale = :fr
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # class Minitest::Unit::TestCase
    #   include FactoryGirl::Syntax::Methods
    # end
    # class Minitest::Spec
    #   include FactoryGirl::Syntax::Methods
    # end



    # config.generators do |g|
    #   g.factory_girl false
    # end
  end
end
