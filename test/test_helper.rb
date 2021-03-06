ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
#require "minitest/reporters"
require 'color_pound_spec_reporter'
#Minitest::Reporters.use! [ColorPoundSpecReporter.new]
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
#Minitest::Reporters.use! [Minitest::Reporters::HtmlReporter , Minitest::Reporters::ProgressReporter, Minitest::Reporters::SpecReporter ]


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  include FactoryBot::Syntax::Methods
  include ApplicationHelper
  def is_logged_in?
    !session[:user_id].nil?
  end
  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end

  def assert_permit(user, record, action)
    msg = "User #{ user.inspect } should be permitted to #{action} #{record}, but isn't permitted"
    assert permit(user, record, action), msg
  end

  def refute_permit(user, record, action)
    msg = "User #{ user.inspect } should NOT be permitted to #{action} #{record}, but is permitted"
    refute permit(user, record, action), msg
  end

  def permit(user, record, action)
    cls = self.class.superclass.to_s.gsub(/Test/, '')
    cls.constantize.new(user, record).public_send("#{action.to_s}?")
  end
end
