class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def logged_in_user
    return false if logged_in?
    store_location
    flash[:danger] = I18n.t('session.log_first')
    redirect_to login_url
  end

  private

  def user_not_authorized
    flash[:danger] = I18n.t('pundit.not_authorized')
    if logged_in?
      redirect_to(request.referrer || root_path)
    else
      redirect_to login_path
    end

  end

end
