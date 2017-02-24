require 'test_helper'

class MissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @mission = missions(:one)
  end

  test "should get edit" do
    get edit_mission_path(@mission)
    assert_response :success
  end

  test "should get new" do
    get new_mission_path
    assert_response :success
  end


  test "should get update" do
    get update_mission_path(@mission)
    assert_response :success
  end

  test "should get show" do
    get mission_path(@mission)
    assert_response :success
  end

  test "should get index" do
    get missions_path
    assert_response :success
  end

end
