class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_url
      else
        flash[:warning] = I18n.t('session.not_logged_message')
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] =  I18n.t('session.fail_logging_message')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url
  end
end
