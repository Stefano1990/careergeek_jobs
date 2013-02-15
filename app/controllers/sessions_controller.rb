class SessionsController < ApplicationController
  def new
  end

  def create
    employer = Recruiter.authenticate(params[:email], params[:password])
    candidate = Candidate.authenticate(params[:email], params[:password])
    if candidate
      session[:candidate_id] = candidate.id
      redirect_to candidate_path(candidate), flash: { success: t("flash.signed_in") }
    elsif employer
      session[:employer_id] = employer.id
      redirect_to employer_path(employer), flash: { success: t("flash.signed_in") }
    else
      flash.now[:error] = t("flash.invalid_login")
      render "new"
    end
  end

  def destroy
    session[:candidate_id] = nil
    session[:employer_id] = nil
    redirect_to root_path, flash: { success: t("flash.signed_out") }
  end
end
