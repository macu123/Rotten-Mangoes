class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      role = user.if_admin == true ? "admin " : ""
      redirect_to movies_path, notice: "Welcome back, #{role}#{user.firstname}!"
    else
      flash.now[:alert] = "Login failed..."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_path, notice: "Adios!"
  end
  
end