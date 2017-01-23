class PeopleController < ApplicationController
  def new
    @person = Person.new
  end
  def index
    @people = Person.paginate(page: params[:page])
  end
  def create
    @person = Person.new(person_params)    # Not the final implementation!
    if @person.save
      flash[:info] = "Compte candidat sauvegardé."
      redirect_to root_url
    else
      render 'new'
    end
  end
  private
    def person_params
      params.require(:person).permit(:title, :firstname, :lastname, :email,:phone_number, :cell_phone_number, :birthdate, :is_jj_hired,:is_client)
    end
end
