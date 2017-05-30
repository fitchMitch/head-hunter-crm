class PeopleController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  def new
    @person = Person.new
  end

  def index
    @q = Person.ransack(params[:q])
    @people = @q.result.page(params[:page] ? params[:page].to_i : 1)
  end

  def edit
    #@person = Person.find(params[:id])
  end
  class Alljob
    include ActiveModel::AttributeAssignment
    attr_accessor :id, :job_title, :start_date, :end_date, :company_name, :salary, :person_id, :no_end, :company_id
  end

  def show
    require 'docx'

    @person = Person.find(params[:id])
    if @person.cv_docx.file?
      pth = "public/" + @person.cv_docx.url.to_s.split("?")[0]
      @doc = Docx::Document.open(pth)
    end

    @job = @person.jobs.build
    @jobs = @person.jobs.includes(:company).reversed_time

    # last_job = @jobs.last
    @alljobs = []
    memo = nil

    @jobs.each do |job|
      unless memo.nil?
        job2 = Alljob.new
        job2.assign_attributes({
          id: 0,
          job_title:  'Sans emploi',
          start_date: job.end_date,
          end_date: memo,
          company_name: 'Pôle emploi',
          company_id: 0,
          salary: 0,
          person_id: job.person_id,
          no_end: false
          })
      end
      job1 = Alljob.new
      job1.assign_attributes({
        id: job.id,
        job_title: job.job_title,
        start_date: job.start_date,
        end_date: job.end_date,
        company_name: job.company.company_name,
        salary: job.salary,
        person_id: job.person_id,
        no_end: job.no_end,
        company_id: job.company_id
        })

      @alljobs << job2 unless memo.nil?
      memo = job1.start_date
      @alljobs << job1
    end
    @class_client = @person.is_client ? 'client' : 'candidate'
  end

  def create
    @person = Person.new(person_params)
    render 'new' if @person.nil?
    @person.cv_docx = params[:person][:cv_docx]
    @person.user_id = current_user.id
    if @person.save
      flash[:success] = 'Contact sauvegardé (' + @person.full_name + ').'
      #redirect_to @person
      goto_next_url people_path
    else
      render 'new'
    end
  end

  def update
    #@person = Person.find(params[:id])
    @person.user_id = current_user.id
    @person.cv_docx = params[:person][:cv_docx]
    if @person.update_attributes(person_params)
      flash[:success] = 'Contact mis à jour'
      redirect_to @person
    else
      flash[:danger] = 'Le contact n\'a pas pu être mis à jour'
      render 'edit'
    end
  end

  def destroy
     mes = 'Contact supprimé'
    if @person.cv_docx.file?
      @person.cv_docx = nil
      mes += @person.save ? ' avec son CV' : ', mais son CV est resté sur le serveur'
    end
    @person.destroy
    flash[:success] = mes
    redirect_to people_url
  end

  def add_company
    set_next_url(person_path(params[:id]))
    redirect_to new_company_path
  end

  #--------------------
  #      PRIVATE
  #--------------------
  private

    def person_params
      #params.require(:person).permit(:title, :firstname, :lastname, :email, :phone_number, :cell_phone_number, :birthdate, :is_jj_hired, :is_client, :note, jobs: [:job_title, :salary, :start_date, :end_date, :jj_job])
      params.require(:person).permit(
        :title,
        :firstname,
        :lastname,
        :email,
        :phone_number,
        :cell_phone_number,
        :birthdate,
        :is_jj_hired,
        :is_client,
        :note,
        :cv_docx
        )
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Logguez-vous d\'abord'
        redirect_to login_url
      end
      unless params[:id].nil?
        @person = Person.find(params[:id])
        @jobs = @person.jobs.includes(:company).reload
      end
    end
end
