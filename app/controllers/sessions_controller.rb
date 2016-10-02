class SessionsController < ApplicationController
  
  def new
    # login page
    redirect_to current_user if logged_in?
  end
  
  def create
    # loging in
    @user = User.find_by_email params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      if params[:session][:remember_me]=="1"
        remember @user
      else
        forget @user
      end
      redirect_back_or @user
    else
      if @user.nil?
        flash.now[:danger] = 'Email doesn\'t exist'
      else
        flash.now[:danger] = 'Invalid email/password combination'
      end
      render 'new'
    end
  end

  def destroy
    # logout
    log_out if logged_in?
    redirect_to root_url
  end
end
