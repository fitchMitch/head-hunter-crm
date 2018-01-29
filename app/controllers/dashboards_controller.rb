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
class DashboardsController < ApplicationController
  before_action :logged_in_user
  before_action :retrieve_user
  before_action :make_periods, only: [:show]

  def show
    @dashboard = Dashboard.new(
      min: @periods[:first_of_month],
      max: @periods[:now],
      user_id: current_user.id
    )
    @current_cash_flow = @dashboard.cash_flow
    @dashboard = Dashboard.new(
      min: @periods[:first_of_last_month],
      max: @periods[:first_of_month],
      user_id: current_user.id
    )
    @last_month_cash_flow = @dashboard.cash_flow
  end

  def make_periods
    now = Time.current
    first_of_month = now.beginning_of_month
    @periods = {
      now: now,
      first_of_month: first_of_month,
      first_of_last_month: first_of_month - 1.month,
      first_of_last_2_month: first_of_month - 2.month,
      first_of_last_3_month: first_of_month - 3.month
    }
  end

  private

  def retrieve_user
    @user = User.find(params[:id])
  end
end
