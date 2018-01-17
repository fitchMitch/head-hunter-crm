class PasswordResetsController < ApplicationController
  before_action :find_user , only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t('mail.reset_instructions')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('mail.not_found')
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, I18n.t('mail.shall_not_empty'))
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = I18n.t('mail.reset')
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end
  # -----------------------
  # ----- PRIVATE PART ----
  # -----------------------
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before filters
    def find_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      condition =  @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url unless condition
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = I18n.t('mail.expired')
        redirect_to new_password_reset_url
      end
    end
end
