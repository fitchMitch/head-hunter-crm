class UsersController < ApplicationController
  before_action :logged_in_user 
  before_action :correct_user,   only: [        :edit, :update, :destroy, :show]

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
    authorize @users
  end

  def show
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
    if @user == current_user
      flash[:success] = I18n.t('user.cannot_destroy')
    else
      admin_list = User.other_admins(@user)
      # Missions are not destroyed but reassigned to the first admin found in the
      # admin list.
      reassign_missions(admin_list.first,@user)
      Person.where('user_id = ?', @user.id).update_all(user_id: admin_list.first.id)
      @user.destroy
      flash[:success] = I18n.t('user.destroyed')
    end
    redirect_to users_url
  end

  private
    def reassign_missions(user_dest,user_to_destroy)
      Mission.transaction do
        Mission.lock.mine(user_to_destroy.id).each do |m|
          m.user_id = user_dest.id
          m.save!
        end
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def correct_user
      @user = User.find(params[:id])
      authorize @user
    end
end
