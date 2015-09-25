class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.if_admin == true
        flash[:notice] = "Welcome back, admin #{user.firstname}!"
      else
        flash[:notice] = "Welcome back, #{user.firstname}!"
      end

      redirect_to movies_path
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