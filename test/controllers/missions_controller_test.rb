require 'test_helper'

class MissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user     = create(:user)
    @admin     = create(:admin)
    @mission   = create(:mission)
    @company   = @mission.company
    @person    = @mission.person
    @some_params = {
        'mission': {
          'name': 'Yet another',
          'start_date':  Date.today.years_ago(10),
          'end_date':  Date.today.years_ago(8),
          'reward':  2222,
          'paid_amount':  111,
          'criteria':  "test",
          'person_id':  @person.id,
          'company_id':  @company.id,
          'user_id':  @user.id,
          'is_done':  false
      }
    }
  end

  test 'shouldn\'t get edit' do
    log_in_as(@user)
    get edit_mission_path(@mission)
    assert_redirected_to root_path
  end

  test 'should get edit' do
    log_in_as(@admin)
    get edit_mission_path(@mission)
    assert_response :success
  end

  test  'should update' do
    log_in_as(@admin)
    patch mission_path(@mission), params: @some_params
    assert_redirected_to mission_path(@mission)
  end

  test 'should create mission' do
    log_in_as(@user)
    get new_mission_path
    post missions_url , params: @some_params
    assert_redirected_to person_url(@person)
  end

  test 'should get new' do
    log_in_as(@user)
    get new_mission_path
    assert_response :success
  end

  test 'should get show' do
    log_in_as(@admin)
    get mission_path(@mission)
    assert_response :success
  end

  test 'should get index' do
    log_in_as(@user)
    get missions_path
    assert_response :success
  end

  test 'admin should see other\'s missions ' do
    log_in_as(@admin)
    get missions_path
    assert_response :success
  end

  test 'shouldn\'t destroy mission' do
    log_in_as(@user)
    assert_no_difference 'Mission.count' do
      delete mission_path(@mission)
    end
    assert_redirected_to root_path
  end

  test 'should destroy mission' do
    log_in_as(@admin)
    assert_difference 'Mission.count',-1 do
      delete mission_path(@mission)
    end
    assert_redirected_to missions_path
  end


end
