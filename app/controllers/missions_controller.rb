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
    @missions = Mission.paginate(page: params[:page])
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
    # ...code
    if @mission.save
      flash[:warning] = message + " (profil imprécis)"
      redirect_to person_path(@person.id)
    else
      flash[:alert] = "Cette expérience n'a pas pu être ajoutée"
      redirect_to person_path(@person.id)
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
