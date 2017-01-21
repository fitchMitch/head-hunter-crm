class CandidatesController < ApplicationController
  def create
    @candidates = Candidate.new
  end
  def index
    @candidates = Candidate.paginate(page: params[:page])
  end
end
