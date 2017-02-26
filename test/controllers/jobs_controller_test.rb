require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user   = users(:michael)
    @person = people(:one)
    @job    = jobs(:one)

    log_in_as(@user)
  end

  test "should get edit" do
    get edit_job_path(@job)
    assert_response :success
  end

  test "should update" do
    patch job_path(@job), params: { job: { salary: 1111 } }
    assert_response :success
  end

  test "should get new" do
    get new_job_path
    assert_response :success
  end

  test "should get index" do
    get jobs_path
    assert_response :success
  end
end
