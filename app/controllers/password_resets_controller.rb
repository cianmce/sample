class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      @user.update_attribute(:reset_digest, nil)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def new
    # reset page to enter email
    if logged_in?
      redirect_to current_user
    end
  end

  def create
    # handle request sent from 'new'
    email = params[:password_reset][:email].downcase
    @user = User.find_by_email(email)
    if @user.nil?
      flash.now[:danger] = "Unknown email: '#{email}'"
      render 'new'
      return
    end
    # user is a real user
    @user.create_reset_digest
    @user.send_reset_email
    flash[:info] = "Please check your email (#{@user.email}) to reset your password."
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "Error reseting password"

        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
