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
    if current_recruiter
      @job.recruiter = current_recruiter
    else
      @job.recruiter_id = 0
    end

    if @job.save
      if @job.blank_recruiter?
        redirect_to job_choose_recruiter_path(@job), flash: { success: "Job was created." }
      else
        redirect_to job_path(@job)
      end
    else
      render "new"
    end
    #if current_recruiter
    #  @recruiter = current_recruiter
    #else
    #  # The recruiter either logs in or creates a new recruiter
    #  unless params[:job][:recruiter][:email].blank?
    #    # The user is trying to log in with an existing recruiter profile
    #    @found_recruiter = Employer.find_by_email(params[:job][:recruiter][:email])
    #    if @found_recruiter && @found_recruiter.authenticate(params[:job][:recruiter][:password])
    #      @recruiter = @found_recruiter
    #      session[:recruiter_id] = @found_recruiter.id # Log the recruiter in at the same time.
    #    else
    #      flash.now[:error] = t("jobs.create.recruiter_not_found")
    #    end
    #  else
    #    # The user is registering as an recruiter and entered: email, password & password confirmation
    #    @new_recruiter = Employer.new(params[:job][:new_recruiter])
    #    if @new_recruiter.save
    #      flash.now[:success] = "Employer saved."
    #      session[:recruiter_id] = @new_recruiter.id # Log the recruiter in at the same time.
    #      @recruiter = @new_recruiter
    #    else
    #      flash.now[:error] = "Your recruiter profile was not saved. Please check your input."
    #    end
    #  end
    #end
    ## Remove the recruiter part from the params:
    #params[:job].delete :recruiter # Otherwise rails complains about not being able to mass-assign recruiter. Which is correct.
    #
    #@job = Job.new(params[:job])
    #@job.recruiter = @recruiter
    #if @job.save!
    #  redirect_to @job, flash: { success: "Your job was saved." }
    #else
    #  render "new"
    #end
  end

  def choose_recruiter
    @job = Job.find(params[:job_id])
  end

  def update
    @job = Job.find(params[:id])
    @recruiter = Recruiter.authenticate(params[:job][:recruiter][:email], params[:job][:recruiter][:password])
    if @recruiter # An recruiter was not found with that email.
      @job.recruiter = @recruiter
      if @job.save
        session[:recruiter_id] = @recruiter.id # Log the recruiter in at the same time.
        redirect_to job_path(@job), flash: { success: "Job was saved and you were logged in." }
      else
        render "choose_recruiter"
      end
    else
      @recruiter = Recruiter.new(params[:job][:new_recruiter])
      if @recruiter.save
        flash.now[:success] = "Employer saved."
        @job.recruiter = @recruiter
        if @job.save
          session[:recruiter_id] = @recruiter.id # Log the recruiter in at the same time.
          redirect_to job_path(@job), flash: { sucecss: "The job was saved and your recruiter account was created." }
        else
          render "choose_recruiter"
        end
      else
        flash.now[:error] = "Employer could not be saved."
        render "choose_recruiter"
      end
    end
  end
end
