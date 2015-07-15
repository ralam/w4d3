class SessionsController < ApplicationController
  before_action :redirect_to_index_if_not_logged_in, except: [:create, :new]

  def create
    @user = User.find_by_credentials(user_params[:username], user_params[:password])
    if @user
      log_in!(@user)
      redirect_to(cats_url)
    else
      flash[:errors] = "Invalid username/password combination"
      @user = User.new(user_params)
      render :new
    end
  end

  def new
    @user = User.new
    render :new
  end

  def destroy
    @user = current_user
    session[:session_token] = nil
    @user.reset_session_token!
    redirect_to cats_url
  end

end
