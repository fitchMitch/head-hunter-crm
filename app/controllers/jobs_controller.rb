class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :get_job,   only: [:edit, :update]

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
  end

  def create
    @person = Person.find(params[:person_id])
    @job = @person.jobs.build(job_params)
    if @job.save
      @company = Company.find(@job.company_id)
      @job.company = @company unless @company.nil?
      message = "Nouvel emploi de " + @job.person.firstname + " sauvegardé " 
      if @job.incomplete_jobs(@person.id)
        flash[:warning] = message + " (profil imprécis)"
      else
        flash[:info] =  message
      end
    else
      flash[:alert] = "Cette expérience n'a pas pu être ajoutée"
    end
    redirect_to person_path(@person.id)
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
      params.require(:job).permit(:job_title, :salary, :start_date, :end_date,:jj_job,:company_id)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
    end
    def get_job
      @job = Job.find(params[:id])
    end
end
