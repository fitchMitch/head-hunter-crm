class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  def sql_perc(s)
    '%' + s.to_s + '%'
  end

  def logged_in_user
    return false if logged_in?
    store_location
    flash[:danger] = 'Logguez-vous d\'abord'
    redirect_to login_url
  end

end
