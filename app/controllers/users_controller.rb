class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t('user.email_activation')
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t('user.profile_update_success')
      redirect_to @user
    else
      flash[:danger] = I18n.t('user.profile_update_failed')
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    admin_list = User.other_admins(@user)
    if @user || admin_list.count === 0
      flash[:success] = I18n.t('user.cannot_destroy')
    else
      Person.where('user_id = ?', @user.id).update_all(user_id: admin_list.first.id)
      @user.destroy
      flash[:success] = I18n.t('user.destroyed')
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def correct_user
      # flash[:danger] = "Logguez vous d'abord"
      @user = User.find(params[:id])
      authorize @user
      redirect_to(root_url) unless current_user? @user
    end

end
