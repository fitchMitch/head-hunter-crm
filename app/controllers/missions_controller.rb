class MissionsController < ApplicationController
  #  id                 :integer          not null, primary key
  #  name               :string
  #  reward             :float
  #  paid_amount        :float
  #  min_salary         :float
  #  max_salary         :float
  #  criteria           :string
  #  min_age            :integer
  #  max_age            :integer
  #  signed             :boolean
  #  is_done            :boolean
  #  created_at         :datetime         not null
  #  updated_at         :datetime         not null
  #  person_id          :integer
  #  company_id         :integer
  #  whished_start_date :date
  before_action :logged_in_user
  before_action :get_mission,   only: [:edit, :show, :update, :destroy]

  def new
    @mission = Mission.new
  end
  #-----------------
  def index
    @status_selected = params[:q].nil? || params[:q]['status_eq'].nil? ? nil : params[:q]['status_eq']
    @q = Mission.ransack(params[:q].try(:merge, m: 'or'))
    @missions = @q.result.includes(:company, :person).page(params[:page] ? params[:page].to_i: 1)

  end
  #-----------------

  def edit
    @person = Person.find(@mission.person_id)
    @company = Company.find(@mission.company_id)
  end
  #-----------------
  def show
  end
  #-----------------
  def create
    @person = Person.find(mission_params[:person_id])
    @company = Company.find(mission_params[:company_id])

    @mission = @person.missions.build(mission_params)
    @mission.status = Mission::STATUS_HOPE
    @mission.is_done = false
    @mission.signed = false

    if !@person.nil? && !@company.nil? && @mission.save
      flash[:info] = 'Mission sauvegardée :-)'
      redirect_to missions_path
    else
      flash[:danger] = 'Cette mission n\'a pas pu être ajoutée'
      render :new
    end
  end

  def update
    @mission.is_done    = [Mission::STATUS_BILLED, Mission::STATUS_PAYED].include?(mission_params[:status])
    @mission.signed     = [Mission::STATUS_SIGNED, Mission::STATUS_BILLED, Mission::STATUS_PAYED].include?(mission_params[:status])

    if @mission.update_attributes(mission_params)
      flash[:success] = 'Mission mise à jour'
      redirect_to @mission
    else
      flash[:danger] = 'Cette mission n\'a pas pu être mise à jour'
      render 'edit'
    end
  end

  def destroy
    @mission.destroy
    flash[:success] = 'Mission supprimée'
    redirect_to missions_path
  end

  def add_ext
    model = params['model'].to_s || 'person'
    dest = 'new_' + model + '_path'
    if params[:id].nil?
      set_next_url new_mission_path
    else
      set_next_url edit_mission_path(params[:id])
    end
    redirect_to send dest
  end

  #---------------
  private
  #---------------
    def mission_params
      params.require(:mission).permit(:name, :reward, :paid_amount, :min_salary, :max_salary, :criteria, :min_age, :max_age, :status, :person_id, :company_id, :whished_start_date)
    end

    def get_mission
      @mission = Mission.find(params[:id])
    end
end
