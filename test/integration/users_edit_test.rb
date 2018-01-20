require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
      @user = create(:user)
      @other_user = create(:user2)
  end

  test  'unsuccessful edit' do
    log_in_as(@user)

    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name:  "", email: "foo@invalid", password: "foo", password_confirmation: "bar" } }
    assert_not flash.empty?
    assert_template 'users/edit'
  end

  test  'failing edit' do
    @user2 = create(:user2)
    log_in_as(@user2)
    get edit_user_path(@user2)
    assert_select "h1" ,I18n.t("user.profile_update")
    name  = 'Foo Bar'
    email = "foo@bar.com"
    patch user_path(@user2), params: { user: { name:  name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_select "h1" ,I18n.t("user.profile_update")
    assert_response :success
  end

  test 'fail editing somebody else's profile (but with friendly forwarding)' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    name  = 'Foo Bar'
    email = "foo@bar.com"
    passw = ""
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password: passw,
                                              password_confirmation: passw } }
    assert_not flash.empty?
    assert_template "users/edit"
    @user.reload
    refute_equal name,  @user.name
    refute_equal email, @user.email
  end

  test 'normal user shouldn't see any user creation link' do

  end

  test 'normal user cannot destroy any other' do
  end
end
