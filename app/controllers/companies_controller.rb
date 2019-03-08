class CompaniesController < ApplicationController
  before_action :logged_in_user
  before_action :find_company, only: [:edit, :update, :show, :list_people]
  def new
    @company = Company.new
  end

  def index
    @q = Company.ransack(params[:q])
    @companies = @q.result.page(params[:page] ? params[:page].to_i : 1)
  end

  def edit
  end

  def show
  end

  def search
    @search_companies = Company.find(params[:q])
  end

  def create
    @company = Company.new(company_params)
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

  # def destroy #not implemented on purpose
  # end

  def list_people
    @nbr = Job.where('company_id = ?', params[:id])
              .distinct
              .pluck(:person_id)
              .count
    params[:q] = {} if params[:q].nil?
    params[:q]['company_id_eq'] = params[:id]
    @q = Job.ransack(params[:q])
    @jobs = @q.result
              .includes(:company, :person)
              .page(pointed_page)

    render 'companies/company_people'
  end

  private
    def company_params
      params.require(:company).permit(
        :company_name,
        :company_representative_id
      )
    end

    def find_company
      @company = Company.find(params[:id])
    end
end
