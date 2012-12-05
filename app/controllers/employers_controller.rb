class EmployersController < ApplicationController
  def new
    @employer = Employer.new
  end

  def show
    @employer = Employer.find(params[:id])
  end

  def edit
    @employer = Employer.find(params[:id])
  end

  def create
    @employer = Employer.new(params[:employer])
    if @employer.save
      redirect_to employer_path(@employer), flash: { success: "Your profile was created." }
    else
      render "new"
    end
  end

  def update
    @employer = Employer.find(params[:id])
    if @employer.update_attributes(params[:employer])
      redirect_to employer_path(@employer), flash: { success: "Your profile was updated." }
    else
      redirect_to edit_employer_path(@employer)
    end
  end

  def destroy
  end

  def index
    @employers = Employer.all
  end
end
