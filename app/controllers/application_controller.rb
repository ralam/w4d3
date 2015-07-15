class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :requesting_user

  def requesting_user(req)
    User.find(req.user_id).username
  end

  def redirect_to_index_if_not_logged_in
    unless current_user
      flash[:errors] = "Must be logged in to perform this action."
      redirect_to cats_url
    end
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def log_in!(user)
    session[:session_token] = user.session_token
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
end
