require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = create(:user)
    remember(@user)
  end

  test 'current_user returns right user when session is nil' do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

<<<<<<< HEAD
  test 'current_user is ok' do
=======
  test 'current_user is ok ' do
>>>>>>> 679db34a8534c1e32c5dfe3bdd869701a74aa0f9
    log_in_as(@user)
    assert_equal current_user, @user, "logged guy is current_user"
  end
end
