require 'test_helper'

class MissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user       = users(:michael)
    @mission    = missions(:one)
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_mission_path(@mission)
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)
    get new_mission_path
    assert_response :success
  end

  test "should get show" do
    log_in_as(@user)
    get mission_path(@mission)
    assert_response :success
  end

  test "should get index" do
    log_in_as(@user)
    get missions_path
    assert_response :success
  end

end
