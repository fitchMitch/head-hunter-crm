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
    @jobs = params[:q].nil? ? [] : Job.where(" job_title LIKE ? ", sqlPerc(params[:q])).paginate(page: params[:page])
    #@search_companies = Person.find(params[:q]) #.paginate(page: params[:page])
    #@search_companies = Mission.find(params[:q]) #.paginate(page: params[:page])
    render 'static_pages/search_results'
  end

end
