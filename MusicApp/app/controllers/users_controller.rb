class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    user = User.new(user_params)
    user.activated = true
    if user.save
      login!(user)
      redirect_to root_path
    else
      flash.now[:errors] = user.errors
      render :new
    end
  end
  
  def activate
    activation_token = params[:activation_token]
    user = User.find_by(activation_token: activation_token)
    if user
      user.update!(activated: true)
      user.save
      login!(user)
      redirect_to root_path
    else
      redirect_to root_path
    end
  end
  
  def user_params
    params[:user].permit(:email, :password)
  end
end