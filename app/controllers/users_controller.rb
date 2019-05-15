class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # Case (1)

  def index
   @users = User.paginate( page: params[:page] )
  end
  # Handle a New user.
  def new
    @user = User.new
  end
  # Handle Show user.
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

  end
  # Handle Create new user.
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
end
  # Handle Edit user.
  def edit
    @user = User.find( params[:id] )
  end
  # Handle update user.
  def update
    if params[ :user][ :password].empty? # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params) # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' # Case (2)
    end
  end
    # Handle Delete user.
  def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted"
      redirect_to users_url
  end
  # Handle To login form user.
  private
  def get_user
    @user = User.find_by(email: params[:email])
  end
  def user_params
    params.require( :user).permit( :password, :password_confirmation)
  end
  # Before filters
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  # Confirms the correct user.
  def correct_user
   @user = User.find(params[:id])
   redirect_to(root_url) unless current_user?(@user)
  end
  # Confirms an admin user.
  def admin_user
  redirect_to(root_url) unless current_user.admin?
  end
  # Confirms a valid user.
  def valid_user
    unless ( @user && @user.activated? &&
      @user.authenticated?( :reset, params[ :id]))
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
