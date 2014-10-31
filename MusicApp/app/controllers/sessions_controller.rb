class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_credentials(session_params[:email], session_params[:password])
    
    if user
      if user.activated
        login!(user)
      else
        flash[:notice] = ["You must activate your account!"]
      end
      redirect_to root_path
    else
      flash.now[:errors] = ["Invalid username/password combination!"]
      render :new
    end
  end
  
  def destroy
    logout!
    redirect_to root_path
  end
  
  def session_params
    params[:session].permit(:email, :password)
  end
end