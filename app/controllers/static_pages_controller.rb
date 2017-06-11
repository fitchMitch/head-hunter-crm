class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def contact
  end

  def about
  end

  def search
    # TODO : trim :q and uppercase
    que = sql_perc(params[:q])
    @people = params[:q].nil? ? [] : Person
      .where(' lastname LIKE  ? OR firstname LIKE  ? ', que, que).paginate(page: params[:page] )
    @person = Person.new
      # --------------
    @companies = params[:q].nil? ? [] : Company.where(' company_name LIKE ? ', que)
      .paginate(page: params[:page])
    @company = Company.new
      # --------------
    @jobs = params[:q].nil? ? [] : Job.where(' job_title LIKE ? ', que)
      .paginate(page: params[:page])
      .joins(:person)
      .includes(:person)
      # --------------
    @missions = params[:q].nil? ? [] : Mission.where(' name LIKE ? OR criteria LIKE ? ', que, que)
      .paginate(page: params[:page])
      .joins(:person)
      .includes(:person)
    @mission = Mission.new
      # --------------
    @comactions = params[:q].nil? ? [] : Comaction.includes(:person).where(' name LIKE ? OR people.firstname LIKE ?  OR people.lastname LIKE ? ', que, que, que)
      .paginate(page: params[:page])
      .joins(:person)
      .includes(:person)
    @comaction = Comaction.new
    @comaction.is_dated = true
    @comaction.name = "Rdv"
    @show_people_details = true

    @nb_results = @people.count + @companies.count + @jobs.count + @missions.count + @comactions.count 

    render 'static_pages/search_results'
  end

  private
  def search_params
    params.permit(:q)
    #code
  end

end
