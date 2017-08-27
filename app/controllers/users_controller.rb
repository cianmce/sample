class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  # after_action :verify_authorized
  # after_action :verify_policy_scoped

  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where
      .not(activated_at: nil)
      .paginate(page: params[:page], :per_page => params[:per_page])
  end

  def show

    @user = User.find(params[:id])
    # @microposts = policy_scope(Micropost).paginate(page: params[:page], :per_page => params[:per_page])
    # authorize @microposts.first
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => params[:per_page])
    # puts Pundit.policy(@user, @microposts.first).something_else?
  end

  def new
    # signup page
    if logged_in?
      redirect_to current_user
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email (#{@user.email}) to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Successful update!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters
    def correct_user
      user = User.find(params[:id])
      unless current_user?(user)
        flash[:danger] = "Unable to view access this page."
        redirect_to root_url
      end
    end

    # Confirms an admin user.
    def admin_user
      user = User.find(params[:id])
      if !current_user.admin? || current_user?(user)
        flash[:danger] = "I'm afraid I can't let you do that."
        redirect_to(root_url)
      end
    end
end
