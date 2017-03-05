require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @job= create(:job)
    @company = @job.company
    @person = @job.person
    @user= @job.person.user

    log_in_as(@user)
  end

  test "should get edit" do
    get edit_job_path(@job)
    assert_response :success
  end

  test "should update" do
    patch job_path(@job), params: { job: {  salary: 1111,
                                            job_title:'testeur',
                                            start_date: '1933-01-25'}
                                   }
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

  test "should show double jobs" do
    job1 = create(:job, no_end:  true, person: @person)
    job2 = create(:job, no_end:  true, person: @person)
    assert job2.double_jobs(@person.id)
  end

end
