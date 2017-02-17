class PeopleController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  def new
    @person = Person.new
  end

  def index
    @people = Person.all.paginate(page: params[:page]).includes(:user)
  end

  def search
    @search_results = params[:q].nil? ? [] : Person.where(" lastname LIKE  ? or firstname LIKE  ? ", sqlPerc(params[:q]), sqlPerc(params[:q])).paginate(page: params[:page])
    @people = @search_results.paginate(page: params[:page]) unless @search_results.empty?
    render  'search'
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
    @action = "/people/" + @person.id.to_s + "/jobs"
    @job = @person.jobs.build
    @jobs = @person.jobs.reload
    @jobs = @person.jobs.includes(:company)
    @class_client = @person.is_client ? "client" : "candidate"
  end

  def create
    @person = Person.new(person_params)
    @person.user_id = current_user.id
    if @person.save
      flash[:info] = "Contact sauvegardé (" + @person.full_name + ")."
      redirect_to @person
    else
      render 'new'
    end
  end

  def update
    @person.user_id = current_user.id
    if @person.update_attributes(person_params)
      flash[:success] = "Contact mis à jour"
      redirect_to @person
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "Contact supprimé"
    redirect_to people_url
  end

  def add_company
    set_next_url(person_path(params[:id]))
    redirect_to new_company_path
  end

  #--------------------
  #      PRIVATE
  #--------------------
  private

    def person_params
      #params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note,jobs: [:job_title, :salary, :start_date, :end_date, :jj_job])
      params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note ,jobs_attributes: [:id, :salary, :job_title, :start_date,:end_date, :jj_job])
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
      unless params[:id].nil?
        @person = Person.find(params[:id])
        @jobs = @person.jobs.includes(:company).reload
      end
    end

    def correct_user
      #flash[:danger] = "Logguez vous d'abord"
      @person = Person.find(params[:id])
    end
end
