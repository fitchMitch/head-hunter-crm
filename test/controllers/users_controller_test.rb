require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = create(:user)
    @other_user = create(:user2)
  end

  test 'should get new'
    log_in_as(@other_user)
    get signup_path
    assert_response :success
  end

  test 'should redirect index when not logged in'
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user'
    log_in_as(@other_user)
    get edit_user_path(@user)
    refute flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user'
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    refute flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in'
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin'
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
