class StaticPagesController < ApplicationController
  # def home
  # end
  #
  # def help
  # end
  #
  # def contact
  # end
  #
  # def about
  # end

  def search
    if params[:quest].nil? || params[:quest]=~/\A\s+\z/
       redirect_to comactions_path
    else
      params[:page] ||= 1

      @jobs = []

      @people = Person.search_name(params[:quest]).includes(:jobs).page(params[:page])
      @person = Person.new
      # --------------
      @companies = Company.search_name(params[:quest]).page(params[:page])
      # --------------
      @missions = Mission.search_name(params[:quest]).includes(:company, :person).page(params[:page])
      # --------------
      @comactions = Comaction.search_name(params[:quest]).includes(:user, :person, mission: [:company]).page(params[:page])

      @nb_results = @people.count + @companies.count + @missions.count + @comactions.count
      render 'static_pages/search_results'
    end
  end

  private
  def search_params
    params.permit(:quest)
  end

end
