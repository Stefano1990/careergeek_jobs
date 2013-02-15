class CandidatesController < ApplicationController
  def new
    @candidate = Candidate.new
  end

  def create
    @candidate = Candidate.new(params[:candidate])
    if @candidate.save
      session[:candidate_id] = @candidate.id
      redirect_to @candidate, flash: { success: "Your profile was created." }
    else
      render "new"
    end
  end

  def show
    @candidate = Candidate.find params[:id]
  end
end
