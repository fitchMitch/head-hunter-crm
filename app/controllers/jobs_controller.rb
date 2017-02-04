class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @job = Job.new
  end

  def index
    @jobs = Job.paginate(page: params[:page])
  end

  def edit
    @job = Job.find(params[:id])
  end

  def show
    @job = Job.find(params[:id])
    #@user = User.find(@job.user_id)
    @comp_names = Company.all
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:info] = "Emploi sauvegardé."
      render 'show'
    else
      render 'new'
    end
  end

  def update
    if @job.update_attributes(job_params)
      flash[:success] = "Emploi mis à jour"
      redirect_to @job
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    flash[:success] = "Emploi supprimé"
    redirect_to jobs_url
  end
  private
    def job_params
      params.require(:job).permit(:job_title, :salary, :start_date, :end_date,:jj_job,:id_job_history,:id_company)
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
      @job = Job.find(params[:id])
    end
end
