require 'test_helper'

class MissionsTest < ActionDispatch::IntegrationTest
  test "admin should see other's missions " do
    @mission   = create(:mission)
    @company   = @mission.company
    @person    = @mission.person
    @some_params = {
        'mission' => {
          'name' => 'Yet another',
          'start_date' =>  Date.today.years_ago(10),
          'end_date' =>  Date.today.years_ago(8),
          'reward' =>  2222,
          'paid_amount' =>  111,
          'criteria' =>  "test",
          'person_id' =>  @person.id,
          'company_id' =>  @company.id,
          'user_id' =>  @user.id,
          'is_done' =>  false
      }
    }
    @user = create(:user)
    log_in_as(@user)
    #add a mission
    get new_mission_path
    post missions_url , @some_params
    assert_redirected_to person_url(@person)
    follow_redirect!
    # disconnect
    delete logout_path
    follow_redirect!
    # login as admin
    @admin = create(:admin)
    log_in_as(@admin)
    get missions_path
    # search in results the added mission
    assert_select ".mission>strong>a", "Yet another"
  end
end
