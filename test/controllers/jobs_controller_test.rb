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
    patch job_path(@job), params: { job: { salary: 1111,job_title:'testeur',start_date: '2016-01-25'} }
    assert_redirected_to person_path(@person)
  end

  test "should get new" do
    get new_job_path
    assert_response :success
  end

  test "should get index" do
    get jobs_path
    assert_response :success
  end

  test "should show double jobs at creation time" do
    post jobs_path, params: { job: {salary: 1111,job_title:'testeur',start_date: '2016-01-25',no_end:true,person_id: @person.id} }
    follow_redirect!
    assert_template 'people/show'
    get new_job_path
    post jobs_path, params: { job: {salary: 22222,job_title:'monogamer',start_date: '2016-01-26',no_end:true,person_id:  @person.id} }
    assert flash[:alert]=="Cette expérience n'a pas pu être ajoutée"
  end
end
