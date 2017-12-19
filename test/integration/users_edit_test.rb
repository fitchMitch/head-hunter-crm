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

  test  'successful edit' do
    @admin = create(:admin)
    log_in_as(@admin)

    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = 'Foo Bar'
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test  'failing edit' do
    @user2 = create(:user2)
    log_in_as(@user2)

    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = 'Foo Bar'
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name, email: email, password: "", password_confirmation: "" } }
    assert_not flash.empty?
    assert_response :success
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = 'Foo Bar'
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test "normal user shouldn't see any user creation link" do

  end

  test "normal user cannot destroy any other" do
  end
end
