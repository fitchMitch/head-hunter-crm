class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :get_company,   only: [:edit, :update]
  def new
    @company = Company.new
  end

  def index
    @companies = Company.paginate(page: params[:page])
  end

  def edit
    @company = Company.find(params[:id])
  end

  def search
    @search_companies = Company.find(params[:q]) #.paginate(page: params[:page])
  end

  def show
    @company = Company.find(params[:id])
  end


  def create
    @company = Company.new(company_params)    # Not the final implementation!
    if @company.save
      flash[:info] = "Société sauvegardée."
      goto_next_url companies_path
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[:success] = "Société mise à jour"
      redirect_to companies_path
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    flash[:success] = "Société supprimée"
    redirect_to companies_path
  end

  def list_people
    distinct_people = {}
    @company = Company.find(params[:id])
    @jobs = Job.where('company_id = ?',params[:id]).joins(:person).includes(:person).select('jobs.job_title as job_t,jobs.start_date start_d,jobs.end_date as end_d,people.firstname as first_n,people.lastname as last_n,people.title as title')
    #puts @jobs.pluck[:last_n]
    @jobs.each do |j|
      #distinct_people<< j[people.title] + " " + j.j
      #distinct_people[j.last_n]+=1
      flash[:alert] = j[:job_t].to_s + "fd "
    end
    @nr_jobs =5 # @jobs.count
    @people = Person.all

    render 'companies/company_people'
  end

  private
    def company_params
      params.require(:company).permit(:company_name)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
    end
    def get_company
      #flash[:danger] = "Logguez vous d'abord"
      @company = Company.find(params[:id])
    end
end
