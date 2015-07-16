class UsersController < ApplicationController
  before_action :redirect_to_index_if_not_logged_in, except: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in!
      redirect_to(cats_url)
    else
      flash.now[:errors] = "Could not create user"
      render :new
    end
  end

  def show
  end
end
