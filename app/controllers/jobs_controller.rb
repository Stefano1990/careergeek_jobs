class JobsController < ApplicationController
  def index
    if params[:category]
      category = Category.find_by_name(params[:category])
      @jobs = Job.where(category_id: category.id).page(params[:page])
      @title = "Found #{@jobs.count} Jobs in #{category.name}"
    else
      @jobs = Job.page(params[:page])
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
    @job = Job.new(params[:job])
    if current_employer
      @job.employer = current_employer
    else
      @job.employer_id = 0
    end

    if @job.save
      if @job.blank_employer?
        redirect_to job_choose_employer_path(@job), flash: { success: "Job was created." }
      else
        redirect_to job_path(@job)
      end
    else
      render "new"
    end
    #if current_employer
    #  @employer = current_employer
    #else
    #  # The employer either logs in or creates a new employer
    #  unless params[:job][:employer][:email].blank?
    #    # The user is trying to log in with an existing employer profile
    #    @found_employer = Employer.find_by_email(params[:job][:employer][:email])
    #    if @found_employer && @found_employer.authenticate(params[:job][:employer][:password])
    #      @employer = @found_employer
    #      session[:employer_id] = @found_employer.id # Log the employer in at the same time.
    #    else
    #      flash.now[:error] = t("jobs.create.employer_not_found")
    #    end
    #  else
    #    # The user is registering as an employer and entered: email, password & password confirmation
    #    @new_employer = Employer.new(params[:job][:new_employer])
    #    if @new_employer.save
    #      flash.now[:success] = "Employer saved."
    #      session[:employer_id] = @new_employer.id # Log the employer in at the same time.
    #      @employer = @new_employer
    #    else
    #      flash.now[:error] = "Your employer profile was not saved. Please check your input."
    #    end
    #  end
    #end
    ## Remove the employer part from the params:
    #params[:job].delete :employer # Otherwise rails complains about not being able to mass-assign employer. Which is correct.
    #
    #@job = Job.new(params[:job])
    #@job.employer = @employer
    #if @job.save!
    #  redirect_to @job, flash: { success: "Your job was saved." }
    #else
    #  render "new"
    #end
  end

  def choose_employer
    @job = Job.find(params[:job_id])
  end

  def update
    @job = Job.find(params[:id])
    @employer = Recruiter.authenticate(params[:job][:employer][:email], params[:job][:employer][:password])
    if @employer # An employer was not found with that email.
      @job.employer = @employer
      if @job.save
        redirect_to job_path(@job), flash: { success: "Job was saved and you were logged in." }
      else
        render "choose_employer"
      end
    else
      @employer = Recruiter.new(params[:job][:new_employer])
      if @employer.save
        flash.now[:success] = "Employer saved."
        session[:employer_id] = @employer.id # Log the employer in at the same time.
        @job.employer = @employer
        @job.save
        redirect_to job_path(@job), flash: { sucecss: "The job was saved and your employer account was created." }
      else
        flash.now[:error] = "Employer could not be saved."
        render "choose_employer"
      end
    end
  end
end
