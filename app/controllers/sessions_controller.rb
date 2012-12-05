class SessionsController < ApplicationController
  def new
  end

  def create
    # The system finds either user/employer based on the combination.
    # Someone can NOT have an employer and user profile with the same email
    employer = Employer.authenticate(params[:email], params[:password])
    user = User.authenticate(params[:email], params[:password])

    if user
      #if !user.activated?
      #  redirect_to root_path, flash: { error: t("flash.not_activated", link: view_context.link_to(t("here"),
      #                                  user_new_activation_mail_path(email: user.email))).html_safe }
      #else
        session[:user_id] = user.id
        redirect_to user_path(user), flash: { success: t("flash.signed_in") }
      #end
    elsif employer
      #if !employer.activated?
      #  redirect_to root_path, flash: { error: t("flash.not_activated", link: view_context.link_to(t("here"),
      #                                  employer_new_activation_mail_path(email: employer.email))).html_safe }
      #else
        session[:employer_id] = employer.id
        redirect_to employer_path(employer), flash: { success: t("flash.signed_in") }
      #end
    else
      flash.now[:error] = t("flash.invalid_login")
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:employer_id] = nil
    redirect_to root_path, flash: { success: t("flash.signed_out") }
  end
end
