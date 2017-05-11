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
    # TODO : trim :q
    que = sql_perc(params[:q])
    @people = params[:q].nil? ? [] : Person.where(" lastname LIKE  ? or firstname LIKE  ? ", que, sql_perc(params[:q])).paginate(page: params[:page])
    @companies = params[:q].nil? ? [] : Company.where(" company_name LIKE ? ", que).paginate(page: params[:page])
    @jobs = params[:q].nil? ? [] : Job.where(" job_title LIKE ? ", que).paginate(page: params[:page]).joins(:person).includes(:person)
    @missions = params[:q].nil? ? [] : Mission.where(" name LIKE ? OR criteria LIKE ? ", que, que).paginate(page: params[:page]).joins(:person).includes(:person)
    @comactions = params[:q].nil? ? [] : Comaction.includes(:person).where(" name LIKE ? OR people.firstname LIKE ? OR people.lastname LIKE ? ", que, que, que).paginate(page: params[:page]).joins(:person).includes(:person)
    @show_people_details = true
    @no_result = (@people.count + @companies.count + @jobs.count + @missions.count ) > 0
    render 'static_pages/search_results'
  end

  private
  def search_params
    params.permit(:q)
    #code
  end

end
