require 'test_helper'

class MissionsTest < ActionDispatch::IntegrationTest
  test "admin should see other's missions " do
    @admin = create(:admin)
    @user = create(:user)
    @person = create(:person)
    @mission   = create(:mission)
    @company   = @mission.company
    @some_params = {
        'mission' => {
          'name' => 'Yet another',
          'whished_start_date' =>  Date.today.years_ago(-8),
          'reward' =>  2222,
          'paid_amount' =>  111,
          'criteria' =>  "test",
          'person_id' =>  @person.id,
          'company_id' =>  @company.id,
          'user_id' => @user.id
      }
    }
    log_in_as(@user)
    #add a mission
    get new_mission_path
    post missions_url ,  params: @some_params
    assert_redirected_to person_url(@person)
    # disconnect
    delete logout_path
    follow_redirect!
    # login as admin
    log_in_as(@admin)
    get missions_path
    # search in results the added mission
    assert_select ".mission>strong>a", "Yet another"
  end
end
