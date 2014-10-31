class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :login!, :logout!, :current_user
  
  def login!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    user.save
  end
  
  def logout!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
    current_user.try(:save)
  end
  
  def current_user
    User.find_by(session_token: session[:session_token])
  end
  
  def require_login
    redirect_to new_session_path unless current_user
  end
end
