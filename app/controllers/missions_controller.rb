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
    @missions = Mission.all

    if params[:filter]
      @missions = @missions.where(["category = ?", params[:filter]])
    end

    if params['sort']
      f = params['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if Mission.new.has_attribute?(field)
        @missions = @missions.order("#{field} #{order}")
      end
    else
        @missions = @missions.order("name ASC")
    end
    @missions = @missions.page(params[:page] ? params[:page].to_i: 1).includes(:company,:person)

    @parameters = {'params'=> params, 'header' => [],'tableDB'=> "missions"}
    @parameters['header']<<{'width'=>2,'label'=>'Mission','attribute'=>'name'}
    @parameters['header']<<{'width'=>1,'label'=>''}
    @parameters['header']<<{'width'=>2,'label'=>'Société','attribute'=>'none'}
    @parameters['header']<<{'width'=>5,'label'=>'Contenu de la mission','attribute'=>'none'}
    @parameters['header']<<{'width'=>1,'label'=>'Date d\'enr.','attribute'=>'updated_at'}

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

    unless (@person.nil? || @company.nil? || @mission.save
      flash[:info] =  "Mission sauvegardée :-)"
      redirect_to :index
    else
      flash[:alert] = "Cette expérience n'a pas pu être ajoutée"
      render :new
    end
  end

  def update
  end

  def destroy
  end
  #---------------
  private
  #---------------
    def mission_params
      params.require(:mission).permit(:name, :reward, :paid_amount, :min_salary, :max_salary, :criteria, :min_age, :max_age, :signed, :is_done,:person_id,:company_id,:whished_start_date)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
    end
    def get_mission
      @mission = Mission.find(params[:id])
    end
end
