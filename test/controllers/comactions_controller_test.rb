require 'test_helper'
# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  action_type:string
#  start_time   :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  mission_id :integer
#  person_id  :integer
class ComactionControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comaction = create(:comaction)
    @mission = create(:mission)
    @person = create(:person)
    @user = create(:user)
  end

  test 'new unlogged fails' do
    get new_comaction_path
    assert_redirected_to login_url
  end

  test "should get show" do
    log_in_as(@user)
    get comaction_path(@comaction)
    assert_response :success
  end

  test 'get new but as logged' do
    log_in_as(@user)
    get new_comaction_path
    assert_response :success
  end

  test 'should redirect destroy when not logged in' do
    log_in_as(@user)
    assert_difference 'Comaction.count', -1 do
      delete comaction_path(@comaction)
    end
    assert_redirected_to comactions_path
  end

  test 'should validate and redirect comaction updates to comactions index page' do
    log_in_as(@user)
    patch comaction_path(@comaction),
          params: {
            comaction: {
              name: '',
              status: Comaction::STATUS_RELATED[-1]
            }
          }
    refute flash.empty?
    assert_redirected_to comactions_path
  end

  test 'should validate and redirect comaction updates ' do
    log_in_as(@user)
    patch comaction_path(@comaction),
          params: {
            comaction: {
              start_time: nil
            }
          }
    refute flash.empty?
    assert_redirected_to comactions_path
  end
  #---------------
  # create
  #---------------
  test 'should create a comaction' do
    log_in_as(@user)
    post comactions_url ,
      params: {
        comaction: {
          name: 'Yet another',
          status: Comaction::STATUS_RELATED[-1],
          person_id: @person.id,
          mission_id: @mission.id,
          user_id: @user.id
        }
    }
    assert_response :success
    assert_template 'comactions/index'
  end
  #---------------
  # edit
  #---------------
  test 'should invalidate strange action_types and redirect comaction edit page ' do
    log_in_as(@user)
    patch comaction_path(@comaction), params: {
      comaction: {
        action_type: 'scrumble master'
      }
    }
    refute flash.empty?
    assert_template 'comactions/calendar'
  end

  test 'should validate comaction edit page ' do
    log_in_as(@user)
    get edit_comaction_path(@comaction)
    patch comaction_path(@comaction), params: {
      comaction: {
        action_type: Comaction::ACTION_TYPES[-1]
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    refute flash.empty?
    assert_template 'comactions/calendar'
  end

  test 'should invalidate upside down dates and redirect comaction edit page ' do
    log_in_as(@user)
    patch comaction_path(@comaction), params: {
      comaction: {
        start_time: @comaction.end_time,
        end_time: @comaction.start_time - 1
      }
    }
    refute flash.empty?, 'Flash never empty'
    assert_template 'comactions/edit'
  end

  test 'should invalidate overlapping comactions' do
    log_in_as(@user)
    @former_comaction = create(:former_comaction)
    delta = @former_comaction.end_time - @former_comaction.start_time
    patch comaction_path(@comaction), params: {
      comaction: {
        start_time: @former_comaction.start_time + 30*60,
        end_time: @former_comaction.end_time + 30*60
      }
    }
    refute flash.empty?, 'Flash never empty'
    assert_template 'comactions/edit'
  end


end
