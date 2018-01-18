require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = create(:user)
    remember(@user)
  end

  test 'current_user returns right user when session is nil'
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong'
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'current_user is ok '
    log_in_as(@user)
    assert_equal current_user, @user, "logged guy is current_user"
  end
end
