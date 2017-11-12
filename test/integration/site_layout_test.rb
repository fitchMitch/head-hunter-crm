require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
      @user = create(:user)
      log_in_as(@user)
  end

  test  'layout links' do
    get root_path
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    get contact_path
    assert_select "title", full_title("Contact")
  end
end
