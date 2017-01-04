class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,:destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end
  def index
    @users = User.paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
    #log_in @user
    #  flash[:success] = "Welcome mon gaillard!"
    #  redirect_to @user
      @user.send_activation_email
      flash[:info] = "Consultez votre boîte à lettres, nous vous avons envoyé un lien d'activation de compte."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profil mis à jour"
      redirect_to @user
    else
      flash[:alert] = "Le profil n'a pas pu être mis à jour"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur supprimé"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Logguez-vous d'abord"
        redirect_to login_url
      end
    end
    def correct_user
      #flash[:danger] = "Logguez vous d'abord"
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? (@user)
    end
    # Confirms an admin user.
    def admin_user
      #current_user TODO
      redirect_to(root_url) unless current_user && current_user.admin?
    end
end
