class RecruitersController < ApplicationController
  def new
    @recruiter = Recruiter.new
  end

  def show
    @recruiter = Recruiter.find(params[:id])
  end

  def edit
    @recruiter = Recruiter.find(params[:id])
  end

  def create
    @recruiter = Recruiter.new(params[:recruiter])
    if @recruiter.save
      session[:recruiter_id] = @recruiter.id
      redirect_to recruiter_path(@recruiter), flash: { success: "Your profile was created." }
    else
      render "new"
    end
  end

  def update
    @recruiter = Recruiter.find(params[:id])
    if @recruiter.update_attributes(params[:recruiter])
      redirect_to recruiter_path(@recruiter), flash: { success: "Your profile was updated." }
    else
      redirect_to edit_recruiter_path(@recruiter)
    end
  end

  def destroy
  end

  def index
    @recruiters = Recruiter.all
  end
end
