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
      render 'show'
    else
      render 'new'
    end
  end

  def update
    if @company.update_attributes(company_params)
      flash[:success] = "Société mise à jour"
      redirect_to @company
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    flash[:success] = "Société supprimée"
    redirect_to root_url
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
