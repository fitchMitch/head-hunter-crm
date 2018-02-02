class Dashboard
  include ActiveModel::AttributeAssignment
  attr_accessor :time_frame, :user_id


  def initialize(attributes)
    att = check_attributes(attributes)
    # if both max and duration are given, max is a priority
    self.time_frame = TimeFrame.new(attributes)
    self.user_id = att[:user_id]
  end

  def check_attributes(attri)
    user_id = attri.fetch(:user_id, 0)
    raise 'missing existing user' if !user_id.is_a?(Fixnum) || user_id == 0
    { user_id: user_id }
  end

  def signed_missions
    @user = retrieve_user
    missions = Mission.where(status: [:contract_signed, :mission_billed, :mission_payed ])
    missions = missions.mine(user_id) unless @user.admin?
    missions.reject { |miss| miss.signed_at.nil? || !time_frame.cover?( miss.signed_at) }
  end

  def cash_flow
    missions = signed_missions
    return 0 if missions.empty?
    cashflow = 0
    missions.each do |mission|
      cashflow += mission.reward unless mission.reward.nil?
    end
    cashflow
  end

  def activity
    all_activity = seconds_worked / available_seconds
    all_activity /= User.count if is_admin?
    all_activity
  end

  def work_to_produce
    missions = related_missions.where(status: [:contract_signed, :contract_sent])
    compute_missing(missions)
  end

  def in_their_pocket
    missions = related_missions.where(status: [:mission_billed])
    compute_missing(missions)
  end
  # ================

  private

    def related_missions
      missions = is_admin? ? Mission.all : Mission.mine(user_id)
      missions.where('signed_at < ? AND signed_at> ?', self.time_frame.max, self.time_frame.min )
    end

    def compute_missing(missions)
      to_collect = missions.sum  do |mission|
        mission.reward - mission.paid_amount
      end
    end

    def retrieve_user
      @user = User.find(user_id)
    end

    def is_admin?
      retrieve_user.admin == true
    end



    def seconds_worked
      comaction_list = is_admin? ? Comaction.all : Comaction.mine(user_id)
      comactions = comaction_list.select do |comaction|
        time_frame.cover?comaction.start_time
      end
      seconds = comactions.sum do |comaction|
        comaction.end_time - comaction.start_time
      end
      seconds
    end

    def available_seconds
      # hours_in_a_day = Comaction::WORK_HOURS.last - Comaction::WORK_HOURS.first
      # TimeFrames start at midnight and close at midnight
      seconds_in_time_frame = self.time_frame.duration * 5 / 7 * hours_per_day / 24
    end

    def hours_per_day
      hours = Comaction::WORK_HOURS.last.to_i - Comaction::WORK_HOURS.first.to_i
    end

    def seconds_per_day
      hours_per_day * 60 * 60
    end

end
