require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new'
    get login_path
    assert_response :success
  end

end
