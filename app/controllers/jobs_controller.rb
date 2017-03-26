class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :get_job,   only: [:edit, :show, :update, :destroy]

  def new
    @job = Job.new
  end
  #-----------------
  def index
    @jobs = Job.paginate(page: params[:page])
    for i in [0..@jobs.count-1] do
      @jobs<< Job.build('job_title'=> "Sans emploi" , 'start_date'=> @jobs[i+1].end_date, 'end_date' => @jobs[i].start_date)
    end
    @jobs.order("end_date")
  end
  #-----------------
  def edit
    @person = Person.find(@job.person_id)
  end
  #-----------------
  # def show
  # end
  #-----------------
  def create
    @person = Person.find(job_params[:person_id])

    @job = @person.jobs.build(job_params)
    @job.end_date = nil if(@job.no_end?)

    if @job.save
      @company = Company.find(@job.company_id)
      @job.company = @company unless @company.nil?
      message = "Nouvel emploi de " + @job.person.firstname + " sauvegardé "
      if @job.double_jobs(@person.id)
        flash[:warning] = message + " (ce profil a plusieurs emplois en parallèle)"
      else
        flash[:info] =  message
      end
    else
      flash[:alert] = "Cette expérience n'a pas pu être ajoutée"
    end

    redirect_to person_path(@person.id)
  end
  #-----------------
  def update
    if @job.update_attributes(job_params)
      flash[:success] = "Emploi mis à jour"
      @person = Person.find(@job.person_id)
      redirect_to @person
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end
  #-----------------
  def destroy
    person_id = @job.person_id
    @job.destroy
    flash[:success] = "Emploi supprimé"
    redirect_to person_path(person_id)
  end
  #-----------------

  #---------------
  private
  #---------------
    def job_params
      params.require(:job).permit(:job_title, :salary, :start_date, :end_date, :jj_job, :company_id, :person_id, :no_end)
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
