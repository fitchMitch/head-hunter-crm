require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = create(:admin)
    @job= create(:job)
    @company = @job.company
    @person = @job.person
    @user= @job.person.user
    @some_params = {
        'job' => {
          'job_title' => 'Yet another',
          'start_date' =>  Date.today.years_ago(10),
          'end_date' =>  Date.today.years_ago(8),
          'salary' =>  2222,
          'jj_job' =>  true,
          'person_id' =>  @person.id,
          'company_id' =>  @company.id,
          'user_id' =>  @user.id,
          'no_end' =>  false
      }
    }
    log_in_as(@user)
  end

  test 'should get edit' do
    get edit_job_path(@job)
    assert_response :success
  end

  test  'should update' do
    patch job_path(@job), params: { job: {  salary: 1111,
                                            job_title:'testeur',
                                            start_date: '1933-01-25' }
                                   }
    assert_redirected_to person_path(@person)
  end

  test 'should get new' do
    get new_job_path
    assert_response :success
  end

  test 'should get index' do
    get jobs_path
    assert_response :success
  end

  test 'should create job' do
    get new_job_path
    post jobs_url , params: @some_params
    assert_redirected_to person_url(@person)
  end

  test 'should redirect to person\'s path list when destroy' do
    assert_difference 'Job.count',-1 do
      delete job_path(@job)
    end
    assert_redirected_to person_path(@person)
  end

  test 'should show double jobs' do
    job1 = create(:job, no_end:  true, person: @person)
    job2 = build(:job, no_end:  true, person: @person)
    assert_not job2.valid?
  end

end
