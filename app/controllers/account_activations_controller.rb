class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = I18n.t('user.authentication.activation')
      redirect_to user
    else
      flash[:danger] = I18n.t('user.authentication.link_no_working')
      redirect_to root_url
    end
  end
end
