class Admin::UsersController < ApplicationController
  before_action :restrict_access

  def index
    @users = User.order("firstname").page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.if_admin = true

    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, admin #{@user.firstname}!"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user), notice: "This user profile is successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user == current_user
      redirect_to admin_user_path(@user), alert: "You cannot delete yourself!"
    else
      @user.destroy
      redirect_to admin_users_path, notice: "The user profile is successfully deleted!"
    end
  end

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must login in."
      redirect_to new_session_path
    elsif current_user.if_admin != true
      flash[:alert] = "You must login in as admin role."
      redirect_to new_session_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end