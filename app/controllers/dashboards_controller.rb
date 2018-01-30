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
  before_action :make_standard_periods, only: [:show]

  def show
    @upper_dashboard = []
    @standard_periods.each_with_index do |instant, index|

      next if instant == @standard_periods.last

      cur_dashboard = Dashboard.new(
        min: @standard_periods[index + 1],
        max: @standard_periods[index],
        user_id: current_user.id
      )

      instant_stats = {
        label_month: cur_dashboard.time_frame.min.strftime("%B"),
        label_year: cur_dashboard.time_frame.min.strftime("%Y"),
        cash_flow: cur_dashboard.cash_flow
      }

      @upper_dashboard << instant_stats
    end
  end

  def make_standard_periods(i = 3)
    now = Time.current
    first_of_month = now.beginning_of_month
    @standard_periods =[now, first_of_month ]
    i.times do |n|
      @standard_periods << first_of_month -(n+1).months
    end
    @standard_periods
  end

  def activity(period)
    # Comaction::
  end

  private

  def retrieve_user
    @user = User.find(params[:id])
  end

  def hours_per_day
    Comaction::WORK_HOURS.last.to_i - Comaction::WORK_HOURS.first.to_i
  end
end
