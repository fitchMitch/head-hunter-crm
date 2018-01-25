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
  before_action :find_comaction,       only: [              :edit, :show, :update, :destroy]
  before_action :retrieve_uid,         only: [:new, :index, :edit]
  before_action :find_availibilities,  only: [:new,         :edit]

  def new
    @comaction = Comaction.new
    authorize @comaction
    @comaction.name = 'RdV'
    @now = DateTime.now.to_date
    @date_begin = params[:date].nil? ? @now : Date.strptime(params[:date], '%Y-%m-%d')
    @forwhom = params[:person_id] || 0
    @what_mission = params[:mission_id] || 0
  end

  def index
    authorize Comaction
    # --- modal material
    @comaction = Comaction.new
    # ----------------------
    @missions = last_missions
    @mission_selected, @status_selected = parameters_selected (params)

    @q = Comaction.mine(@uid).ransack(params[:q])
    @comactions = @q.result.includes(:user, :person, mission: [:company])

    unless params[:filter].nil? 
      Comaction.statuses.each do |key,value|
        @comactions = @comactions.public_send(key) if params[:filter] == key
      end
      @comactions = if params[:filter] == 'future'
        @comactions.newer_than 0
      elsif params[:filter] == 'mission_id'
        @comactions.mission_id(@q[:mission_id])
      else
        @comactions.newer_than 21 # Three weeks
      end
      @comactions = @comactions.unscheduled if params[:filter] == 'unscheduled'
    end

    @filter = nil || params[:filter]
    # ---------- view choice ---------------
    if params[:v].nil? || params[:v] != 'table_view'
      render 'calendar'
    else
      params[:page] ||= 1
      @comactions = @comactions.page(params[:page])
      render 'index'
     end
  end

  def edit
    @user = current_user
    @forwhom = @comaction.person.id
    @date_start, @date_end = @comaction.start_time, @comaction.end_time
  end

  def show ; end

  def create
    @person = Person.find(comaction_params[:person_id])
    @mission = Mission.find(comaction_params[:mission_id])
    @comaction = @person.comactions.build(comaction_params)
    @comaction.user_id = current_user.id
    @comaction = trigger_nil_dates @comaction
    authorize @comaction

    if @comaction.save
      if @comaction.start_time.nil?  || @comaction.end_time.nil? || !Rails.configuration.mail_wanted
        flash[:info] = I18n.t('comaction.message.saved')
      else
        @comaction.send_meeting_email(current_user, true)
        flash[:info] = I18n.t('comaction.message.saved_with_mail')
      end
      redirect_to comactions_path
    else
      flash[:danger] = I18n.t('comaction.message.unsaved')
      render :new
    end
  end

  def update
    @comaction = trigger_nil_dates @comaction
    if @comaction.update(comaction_params)
      if @comaction.start_time.nil? || @comaction.end_time.nil? || !Rails.configuration.mail_wanted
        flash[:success] = I18n.t('comaction.message.saved')
      else
        @comaction.send_meeting_email(current_user, false)
        flash[:success] = I18n.t('comaction.message.updated_with_mail')
      end
      logger.warn("update won\'t work #{@comaction.inspect}")
      redirect_to comactions_path
    else
      logger.warn("update won\'t work #{@comaction.inspect}")
      flash[:danger] = I18n.t('comaction.message.unupdated')
      render 'edit'
    end
  end

  def destroy
    @comaction.destroy
    flash[:success] = I18n.t('comaction.message.deleted')
    redirect_to comactions_path
  end

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

  # ---------------
  private
  # ---------------
    def last_missions
      missions = []
      Comaction.all.mine(@uid).limit(20).each do |comac|
        missions << comac.mission
      end
      missions = missions.sort { |a, b| b.updated_at <=> a.updated_at }.uniq &:id
    end

    def parameters_selected (params)
      c1 = params[:q].nil? || params[:q]['mission_id_eq'].nil?
      @mission_selected = c1 ? 0 : params[:q]['mission_id_eq']
      @status_selected = params[:filter].nil? ? 'none' : params[:filter]
      return @mission_selected, @status_selected
    end
    # =================
    # AVailibility preview
    # =================
    def next_comactions
      next_comactions_event_slots = []
      next_c = Comaction.mine(@uid).newer_than(0).older_than(Comaction::PERSPECTIVE, true).order(start_time: :asc)
      next_c.each do |nc|
        next_comactions_event_slots << EventSlot.new({min: nc.start_time, max: nc.end_time})
      end
      next_comactions_event_slots
    end

    def availibilities (next_comactions)
      # reminder : next_comactions are EventSlots
      d = Time.current
      attributes = { min: d, duration: Comaction::PERSPECTIVE.days }
      free_zone = EventSlot.new(attributes)
      free_zone_days = free_zone.dash_it next_comactions
      free_zone_days = EventSlot.sort_periods free_zone_days unless free_zone_days.nil?
    end

    def trigger_nil_dates(comaction)
      unless comaction_params[:is_dated].to_i == 1
        comaction.start_time = nil
        comaction.end_time = nil
      end
      comaction
    end

    # A list of the param names that can be used for filtering the Product list
    def filtering_params(params)
      params.slice(Comaction::ACTION_TYPES_NAMES.values)
    end

    def comaction_params
      params.require(:comaction).permit(
        :name,
        :status,
        :action_type,
        :start_time,
        :end_time,
        :user_id,
        :mission_id,
        :person_id,
        :is_dated
      )
    end

    def find_comaction
      authorize Comaction
      @comaction = Comaction.find(params[:id])
      @comaction.is_dated = (@comaction.nil? || @comaction.start_time.nil?) ? 0 : 1
      @date_begin = @comaction.start_time
      @date_end = @comaction.end_time
    end

    def retrieve_uid
      @uid = current_user.id
    end

    def find_availibilities
      @next_comactions = next_comactions
      @free_zone_days = availibilities @next_comactions
    end
end
