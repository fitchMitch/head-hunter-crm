class PeopleController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  def new
    @person = Person.new
  end

  def index
    @people = Person.paginate(page: params[:page])
    #TODO : c'est un foreach ici pour ajouter à people un attribut username avec User.find(pers.user_id)
    @people.each do |pers|
      
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
    @user = User.find(@person.user_id)
  end

  def create
    @person = Person.new(person_params)
    @person.user_id = current_user.id
    if @person.save
      flash[:info] = "Contact sauvegardé."
      render 'show'
    else
      render 'new'
    end
  end

  def update
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
  private
    def person_params
      params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client,:note)
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
      @person = Person.find(params[:id])
    end
end
