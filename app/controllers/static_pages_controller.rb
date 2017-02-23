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
    @people = params[:q].nil? ? [] : Person.where(" lastname LIKE  ? or firstname LIKE  ? ", sqlPerc(params[:q]), sqlPerc(params[:q])).paginate(page: params[:page])
    @companies = params[:q].nil? ? [] : Company.where(" company_name LIKE ? ", sqlPerc(params[:q])).paginate(page: params[:page])
    @jobs = params[:q].nil? ? [] : Job.where(" job_title LIKE ? ", sqlPerc(params[:q])).paginate(page: params[:page]).joins(:person).includes(:person)
    @show_people_details = true
    @no_result = (@people.count + @companies.count + @jobs.count) > 0
    render 'static_pages/search_results'
  end

  private
  def search_params
    params.permit(:q)
    #code
  end

end
