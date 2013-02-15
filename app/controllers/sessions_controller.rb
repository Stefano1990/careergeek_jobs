class SessionsController < ApplicationController
  def new
  end

  def create
    recruiter = Recruiter.authenticate(params[:email], params[:password])
    candidate = Candidate.authenticate(params[:email], params[:password])
    if candidate
      session[:candidate_id] = candidate.id
      redirect_to candidate_path(candidate), flash: { success: t("flash.signed_in") }
    elsif recruiter
      session[:recruiter_id] = recruiter.id
      redirect_to recruiter_path(recruiter), flash: { success: t("flash.signed_in") }
    else
      flash.now[:error] = t("flash.invalid_login")
      render "new"
    end
  end

  def destroy
    session[:candidate_id] = nil
    session[:recruiter_id] = nil
    redirect_to root_path, flash: { success: t("flash.signed_out") }
  end
end
