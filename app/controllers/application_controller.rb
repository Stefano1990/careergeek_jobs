class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_recruiter
    if session[:recruiter_id]
      if Recruiter.find_by_id(session[:recruiter_id])
        @current_recruiter ||= Recruiter.find(session[:recruiter_id])
      else
        session[:recruiter_id] = nil # Invalid session[:recruiter_id]
        @current_recruiter = nil
      end
    end
    @current_recruiter
  end
  helper_method :current_recruiter

  def current_candidate
    if session[:candidate_id]
      if candidate.find_by_id(session[:candidate_id])
        @current_candidate ||= candidate.find(session[:candidate_id])
      else
        session[:candidate_id] = nil # Invalid session[:candidate_id]
        @current_candidate = nil
      end
    end
    @current_candidate
  end
  helper_method :current_candidate
end
