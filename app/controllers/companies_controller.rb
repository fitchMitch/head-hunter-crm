class CompaniesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :get_company,   only: [:edit, :update]
  def new
    @company = Company.new
  end

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.page(params[:page] ? params[:page].to_i : 1)
  end

  def edit
    @company = Company.find(params[:id])
  end

  def search
    @search_companies = Company.find(params[:q])
  end

  def show
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(company_params)    # Not the final implementation!
    if @company.save
      flash[:info] = 'Société sauvegardée.'
      goto_next_url companies_path
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[:success] = 'Société mise à jour'
      redirect_to companies_path
    else
      flash[:danger] = 'Le contact n\'a pas pu être mis à jour'
      render 'edit'
    end
  end

  # def destroy
  #   Company.find(params[:id]).destroy
  #   flash[:success] = 'Société supprimée'
  #   redirect_to companies_path
  # end

  def list_people
    @company = Company.find(params[:id])
    @nbr = Job.where('company_id = ?', params[:id]).distinct.pluck(:person_id).count
    #@comactions = Comaction.includes(:user, :person, mission: [:company])
    params[:q] = {} if params[:q].nil?
    params[:q]['company_id_eq'] = params[:id]
    @q = Job.ransack(params[:q])
    @jobs = @q.result.includes(:company, :person).page(params[:page] ? params[:page].to_i : 1)

    render 'companies/company_people'
  end

  private
    def company_params
      params.require(:company).permit(:company_name)
    end

    def get_company
      #flash[:danger] = "Logguez vous d'abord"
      @company = Company.find(params[:id])
    end
end
