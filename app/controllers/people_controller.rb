class PeopleController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  def new
    @person = Person.new
  end

  def index
    @people = Person.paginate(page: params[:page])
    #TODO : c'est un foreach ici pour ajouter à people un attribut username avec User.find(pers.user_id)

  end

  def search
    @search_results = params[:q].nil? ? [] : Person.where(" lastname LIKE  ? or firstname LIKE  ? ", perc(params[:q]), perc(params[:q])).paginate(page: params[:page])
    #@search_results = Person.where("lastname LIKE %?% or firstname LIKE %?%", params[:q], params[:q])
    @people = @search_results.paginate(page: params[:page]) unless @search_results.empty?
    #@search_results = Person.where("is_client = ?", true)
    render  'search'
  end

  def searchByName
    @search_results = []
    #@search_results = Person.where("lastname LIKE %?% or firstname LIKE %?%", params[:q], params[:q])
    #@search_results = Person.where("lastname LIKE % ? % or firstname LIKE % ? %", params[:q], params[:q])
    #@search_results = Person.take(2).paginate(page: params[:page]) unless @search_results.empty?
    #@search_results = Person.where("is_client = ?", true)
    render 'search'
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
    @comp_names = Company.all
    @class_client = @person.is_client ? "client" : "candidate"
  end

  def add_job
    #@micropost = current_user.microposts.build(micropost_params)
    @person = Person.find(params[:id])
    @job = @person.job.build(job_params)
    if @job.save
      flash[:info] = "Emploi sauvegardé."
    end
    render 'show'
  end

  def create
    @person = Person.new(person_params)
    @person.user_id = current_user.id
    if @person.save
      flash[:info] = "Contact sauvegardé."
      render 'show'
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

  #--------------------
  #      PRIVATE
  #--------------------
  private
    def perc(s)
      '%' + s.to_s + '%'
    end
    def person_params
      params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note)
    end
    def job_params
      params.require(:job).permit(:job_title, :salary, :start_date, :end_date, :jj_job)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
    end
    def correct_user
      #flash[:danger] = "Logguez vous d'abord"
      @person = Person.find(params[:id])
    end
end
