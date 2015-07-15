class SessionsController < ApplicationController

  def create
    @user = User.find_by_credentials(user_params[:username, :password])
    if @user
      log_in!(@user)
      redirect_to(:index)
    else
      flash[:errors] = "Invalid username/password combination"
      render :new
    end
  end

  def new
  end

  def destroy
  end

end
