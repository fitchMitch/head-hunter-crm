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
    missions.collect { |mission| mission if !mission.signed_at.nil? && time_frame.cover?( mission.signed_at) }
  end

  def cash_flow
    missions = self.signed_missions.compact
    return 0 if missions.empty?
    cashflow = 0
    missions.each do |mission|
      cashflow += mission.reward unless mission.reward.nil?
    end
    cashflow
  end

  def retrieve_user
    @user = User.find(user_id)
  end

end
