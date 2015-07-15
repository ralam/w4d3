class UsersController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to(user_url)
    else
      flash.now[:errors] = "Could not create user"
      render :new
    end
  end

  private

end
