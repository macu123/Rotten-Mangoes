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

    if @user.save
      role = @user.if_admin == true ? "admin" : "normal"
      redirect_to admin_users_path, notice: "The #{role} user #{@user.full_name} was created successfully!"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user), notice: "#{@user.full_name}'s profile was successfully updated!"
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
      redirect_to admin_users_path, notice: "The #{@user.full_name}'s profile and related reviews were successfully deleted!"
    end
  end

  protected

  def restrict_access
    if !current_user
      role = ""
    elsif current_user.if_admin != true
      role = " as admin role"
    else
      return
    end

    flash[:alert] = "You must login in#{role}."
    redirect_to new_session_path
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :if_admin)
  end
end