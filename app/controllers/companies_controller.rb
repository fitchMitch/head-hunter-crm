class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [ :index, :edit, :update,:destroy]
  before_action :get_company,   only: [ :edit, :update]
  def new
    @company = Company.new
  end

  def index
    @companies = Company.all

    if params[ :filter]
      @companies = @companies.where(["category = ?", params[ :filter]])
    end

    if params['sort']
      f = params['sort'].split(', ').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if Company.new.has_attribute?(field)
        @companies = @companies.order("#{field} #{order}")
      end
    else
        @companies = @companies.order( 'company_name ASC')
    end
    @companies = @companies.page(params[ :page] ? params[ :page].to_i : 1)

    @parameters = { 'params'=> params, 'header' => [], 'tableDB'=> 'companies' }
    @parameters['header']<<{ 'width'=> 3, 'label'=>'Société', 'attribute'=>'company_name' }
    @parameters['header']<<{ 'width'=> 2, 'label'=>'' }
    @parameters['header']<<{ 'width'=> 3, 'label'=>'Date d\'enregistrement', 'attribute'=>'created_at' }
  end

  def edit
    @company = Company.find(params[ :id])
  end

  def search
    @search_companies = Company.find(params[ :q]) #.paginate(page: params[ :page])
  end

  def show
    @company = Company.find(params[ :id])
  end

  def create
    @company = Company.new(company_params)    # Not the final implementation!
    if @company.save
      flash[ :info] = "Société sauvegardée."
      goto_next_url companies_path
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[ :success] = "Société mise à jour"
      redirect_to companies_path
    else
      flash[ :danger] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Company.find(params[ :id]).destroy
    flash[ :success] = "Société supprimée"
    redirect_to companies_path
  end

  def list_people
    #@comactions = Comaction.includes(:user, :person, mission: [ :company])
    @company = Company.find(params[ :id])
    @jobs = Job.where('company_id = ?', params[ :id]).includes(:person)
    @jobs = bin_filters(@jobs, params)
    @jobs = reorder(@jobs, params, 'job_title')

    @nbr = Job.where('company_id = ?', params[ :id]).distinct.pluck(:person_id).count

    @parameters = { 'params'=> params, 'header' => [], 'tableDB'=> 'companies', 'action'=>'list_people' }

    @parameters['header']<<{ 'width'=> 3, 'label'=>'Personne', 'attribute'=>'people.lastname' }
    @parameters['header']<<{ 'width'=> 3, 'label'=>'Emploi', 'attribute'=>'job_title' }
    @parameters['header']<<{ 'width'=> 3, 'label'=>'Dates', 'attribute'=>'start_date' }

    render 'companies/company_people'
  end

  private
    def company_params
      params.require(:company).permit(:company_name)
    end

    def get_company
      #flash[ :danger] = "Logguez vous d'abord"
      @company = Company.find(params[ :id])
    end
end
