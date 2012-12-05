class JobsController < ApplicationController
  def index
    @featured_jobs = Job.all
    if params[:category]
      category = Category.find_by_name(params[:category])
      @jobs = Job.where(category_id: category.id)
      @title = "Jobs in #{category.name}"
    else
      @jobs = Job.all
      @title = "Latest jobs"
    end
  end

  def show
    @job = Job.find(params[:id])
    @job.increase_view_counter(request.env["HTTP_X_FORWARD_FOR"] || request.remote_ip)
  end

  def new
    @job = Job.new
  end

  def create
    # Employer is logged in:
    if current_employer
      @employer = current_employer
    else
      # The employer either logs in or creates a new employer
      unless params[:job][:employer][:email].blank?
        # The user is trying to log in with an existing employer profile
        @found_employer = Employer.find_by_email(params[:job][:employer][:email])
        if @found_employer && @found_employer.authenticate(params[:job][:employer][:password])
          @employer = @found_employer
          session[:employer_id] = @found_employer.id # Log the employer in at the same time.
        else
          flash.now[:error] = t("jobs.create.employer_not_found")
        end
      else
        # The user is registering as an employer and entered: email, password & password confirmation
        @new_employer = Employer.new(params[:job][:new_employer])
        if @new_employer.save
          flash.now[:success] = "Employer saved."
          session[:employer_id] = @new_employer.id # Log the employer in at the same time.
          @employer = @new_employer
        else
          flash.now[:error] = "Your employer profile was not saved. Please check your input."
        end
      end
    end
    # Remove the employer part from the params:
    params[:job].delete :employer # Otherwise rails complains about not being able to mass-assign employer. Which is correct.

    @job = Job.new(params[:job])
    @job.employer = @employer
    if @job.save
      redirect_to @job, flash: { success: "Your job was saved." }
    else
      render "new"
    end
  end
end
