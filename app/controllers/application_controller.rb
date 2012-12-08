class ApplicationController < ActionController::Base
  protect_from_forgery
  def current_employer
    if session[:employer_id]
      if Employer.find_by_id(session[:employer_id])
        @current_employer ||= Employer.find(session[:employer_id])
      else
        session[:employer_id] = nil # Invalid session[:employer_id]
        @current_employer = nil
      end
    end
    @current_employer
  end
  helper_method :current_employer
end
