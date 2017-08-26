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
class ComactionsController < ApplicationController

  before_action :logged_in_user
  before_action :get_comaction,   only: [:edit, :show, :update, :destroy]
  before_action :get_uid,   only: [:new, :index]

  def new
    @comaction = Comaction.new
    @comaction.name = 'RdV'
    @date = params[:date] == nil ? DateTime.now.to_date :  Date.strptime(params[:date], "%Y-%m-%d")
    @forwhom = params[:person_id] || 0
    @what_mission = params[:mission_id] || 0
    # =================
    # AVailibility preview
    # =================
    #just looking into next week
    @next_comactions = Comaction.mine(@uid).newer_than(0).older_than(5).order(start_time: :asc)
    #---
    d = DateTime.current
    attributes = {:start_period => d , :end_period => d.advance(days: 5)}
    @freeZone_days = EventSlot.new(attributes).working_days_split
    #---
    dash_it = EventSlot.dash_it(@freeZone_days, @next_comactions)
    flash[:danger] = dash_it[:messages] unless dash_it[:messages].empty?
    @freeZone_days = dash_it[:freeZone_days]

    @freeZone_days = EventSlot.sharpen(@freeZone_days)
    @freeZone_days = EventSlot.sort_periods(@freeZone_days) unless @freeZone_days == nil
    #---
  end


  #-----------------
  def index

    params[:page] ||= 1
    @q = Comaction.mine(@uid).ransack(params[:q])
    @comactions = @q.result.includes(:user, :person, mission: [:company])
    unless params[:filter].nil?
      Comaction::STATUS_RELATED.values.each do |key|
        @comactions = @comactions.public_send(key)  if params[:filter].to_sym == key
      end
      if params[:filter] === 'future'
        @comactions = @comactions.newer_than 0
      else
        @comactions = @comactions.newer_than 21
      end
      @comactions = @comactions.unscheduled if params[:filter] === 'unscheduled'
    end
    @comactions = @comactions.page(params[:page])
    # --- modal material
    @comaction = Comaction.new
    # @date = params[:date] == nil ? DateTime.now.to_date :  Date.strptime(params[:date], "%Y-%m-%d")
    # @forwhom = params[:person_id] || 0
    # @what_mission = params[:mission_id] || 0
    # ---------- view choice ---------------
    if params[:v].nil? || params[:v] != 'table_view'
      render 'calendar'
    else
      render 'index'
     end
  end
  #-----------------
  def edit
    @user = current_user
    @forwhom = @comaction.person.id
    @date_start, @date_end = @comaction.start_time , @comaction.end_time
  end
  #-----------------
  def show
  end
  #-----------------
  def add_ext
    if params[:id].nil?
      set_next_url new_comaction_path
    else
      set_next_url edit_comaction_path(params[:id])
    end
    model = params['model'].to_s || 'person'
    dest = 'new_' + model + '_path'
    redirect_to send dest
  end
  #-----------------
  def create
    @person = Person.find(comaction_params[:person_id])
    @mission = Mission.find(comaction_params[:mission_id])

    @comaction = @person.comactions.build(comaction_params)
    #@comaction.mission_id = @mission.id
    @comaction.user_id = current_user.id
    @comaction = trigger_nil_dates @comaction

    if @comaction.save
      if @comaction.start_time == nil  || @comaction.end_time == nil
        flash[:info] = I18n.t("comaction.message.saved")
      else
        @comaction.send_meeting_email(current_user, 1)
        flash[:info] =  I18n.t("comaction.message.saved_with_mail")
      end
      redirect_to comactions_path
    else
      flash[:danger] =  I18n.t("comaction.message.unsaved")
      render :new
    end
  end

  def update
    @comaction = trigger_nil_dates @comaction

    if @comaction.update_attributes(comaction_params)
      if @comaction.start_time == nil || @comaction.end_time == nil
        flash[:success] = I18n.t("comaction.message.saved")
      else
        @comaction.send_meeting_email(current_user, 0)
        flash[:success] = I18n.t("comaction.message.updated_with_mail")
      end
      logger.warn("update won\'t work #{@comaction.inspect }")
      redirect_to comactions_path
    else
      logger.warn("update won\'t work #{@comaction.inspect }")
      flash[:danger] = I18n.t("comaction.message.unupdated")
      render 'edit'
    end
  end

  def destroy
    @comaction.destroy
    flash[:success] = I18n.t("comaction.message.deleted")
    redirect_to comactions_path
  end


  #---------------
  private
  #---------------
    def trigger_nil_dates (comaction)
      unless comaction_params[:is_dated].to_i == 1
        comaction.start_time = nil
        comaction.end_time = nil
      end
      comaction
    end
  # A list of the param names that can be used for filtering the Product list
    def filtering_params(params)
      params.slice(Comaction::STATUS_RELATED.values)
    end

    def comaction_params
      params.require(:comaction).permit(:name, :status, :action_type, :start_time, :end_time, :user_id, :mission_id, :person_id, :is_dated)
    end

    def get_comaction
      @comaction = Comaction.find(params[:id])
      @comaction.is_dated = @comaction.nil? || @comaction.start_time.nil?  ? 0 : 1
      @date_begin = @comaction.start_time
      @date_end = @comaction.end_time
    end

    def get_uid
      @uid = current_user.id
    end
end
