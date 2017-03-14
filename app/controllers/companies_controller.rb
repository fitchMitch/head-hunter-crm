class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :get_company,   only: [:edit, :update]
  def new
    @company = Company.new
  end

  def index
    @companies = Company.all

    if params[:filter]
      posts = posts.where(["category = ?", params[:filter]])
    end

    if params['sort']
      f = params['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if Company.new.has_attribute?(field)
        @companies = @companies.order("#{field} #{order}")
      end
    else
        @companies = @companies.order("company_name ASC")
    end
    @companies = @companies.page(params[:page] ? params[:page].to_i: 1)

    @params = params

    @header=[]
    @header<<{'width'=>3,'label'=>'Société','attribute'=>'company_name'}
    @header<<{'width'=>2,'label'=>'','attribute'=>'company_name'}
    @header<<{'width'=>3,'label'=>'Date d\'enregistrement','attribute'=>'created_at'}

    @tableDB =  "companies"

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
    @company = Company.find(params[:id])
    @jobs = Job.where('company_id = ?',params[:id]).joins(:person).includes(:person).select('jobs.job_title as job_t,jobs.start_date start_d,jobs.end_date as end_d,jobs.person_id,people.firstname as first_n,people.lastname as last_n,people.title as title')

    distinct_people_ids = @jobs.pluck(:person_id).uniq || []
    @people_jobs = {}
    distinct_people_ids.each  {|val|
      @people_jobs[val] = { 'jobs' => [],'person' => {}}
    }

    @jobs.each { |j|
      @people_jobs[j.person_id]['jobs'] << {"job_title" =>j.job_title,"start_date" =>j.start_date,"end_date" =>j.end_date}
      @people_jobs[j.person_id]['person'] = {'title'=>j.person.title , 'firstname'=>j.person.firstname,'lastname'=>j.person.lastname}
    }
    @nb_people = distinct_people_ids.count

    render 'companies/company_people'
  end

  def sort_col
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
