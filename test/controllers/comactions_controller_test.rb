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
    @user = create(:user)
  end

  test 'new unlogged fails' do
    get new_comaction_path
    assert_redirected_to login_url
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
    assert_template 'comactions/edit'
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

  test 'should invalidate overlapping comactions ' do
    log_in_as(@user)
    @former_comaction = create(:former_comaction)
    delta = @former_comaction.end_time - @former_comaction.start_time
    patch comaction_path(@comaction), params: {
      comaction: {
        start_time: @former_comaction.start_time + 1/48,
        end_time: @former_comaction.end_time + 1/48
      }
    }
    refute flash.empty?, 'Flash never empty'
    assert_template 'comactions/edit'
  end
end
