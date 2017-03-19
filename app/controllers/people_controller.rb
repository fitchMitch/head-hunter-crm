class PeopleController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]

  def new
    @person = Person.new
  end

  def index
    @people = Person.all

    if params[:filter]
      @people = @people.where(["category = ?", params[:filter]])
    end

    if params['sort']
      f = params['sort'].split(',').first
      field = f[0] == '-' ? f[1..-1] : f
      order = f[0] == '-' ? 'DESC' : 'ASC'
      if Person.new.has_attribute?(field)
        @people = @people.order("#{field} #{order}")
      end
    else
      @people = @people.order("firstname ASC")
    end
    @people = @people.page(params[:page] ? params[:page].to_i: 1).includes(:user)

    @parameters = {'params'=> params, 'header' => [],'tableDB'=> "people"}
    @parameters['header']<<{'width'=>3,'label'=>'Contact','attribute'=>'lastname'}
    @parameters['header']<<{'width'=>2,'label'=>''}
    @parameters['header']<<{'width'=>3,'label'=>'Date d\'enregistrement','attribute'=>'created_at'}
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
    @job = @person.jobs.build
    @jobs = @person.jobs.reload.includes(:company)
    @class_client = @person.is_client ? "client" : "candidate"
  end

  def create
    @person = Person.new(person_params)
    @person.user_id = current_user.id
    if @person.save
      flash[:success] = "Contact sauvegardé (" + @person.full_name + ")."
      redirect_to @person
    else
      render 'new'
    end
  end

  def update
    #@person = Person.find(params[:id])
    @person.user_id = current_user.id
    if @person.update_attributes(person_params)
      flash[:success] = "Contact mis à jour"
      redirect_to @person
    else
      flash[:alert] = "Le contact n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "Contact supprimé"
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
      #params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note,jobs: [:job_title, :salary, :start_date, :end_date, :jj_job])
      params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note ,jobs_attributes: [:id, :salary, :job_title, :start_date,:end_date, :jj_job])
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
      unless params[:id].nil?
        @person = Person.find(params[:id])
        @jobs = @person.jobs.includes(:company).reload
      end
    end
end
