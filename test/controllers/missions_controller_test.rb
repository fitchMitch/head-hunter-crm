require 'test_helper'

class MissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user     = users(:michael)
    mission   = create(:mission)
    company   = mission.company
    person    = mission.person
    log_in_as(@user)
  end

  test "should get edit" do
    get edit_mission_path(mission)
    assert_response :success
  end

  test "should get new" do
    get new_mission_path
    assert_response :success
  end

  test "should get show" do
    get mission_path(mission)
    assert_response :success
  end

  test "should get index" do
    log_in_as(@user)
    get missions_path
    assert_response :success
  end

end
