require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @person    = people(:one)
    log_in_as(@user)
  end

  test "should get edit" do
    get edit_person_path(@person)
    assert_response :success
  end

  test "should get new" do
    get new_person_path
    assert_response :success
  end

  test "should get show" do
    get person_path(@person)
    assert_response :success
  end

  test "should get index" do
    get people_path
    assert_response :success
  end

end
