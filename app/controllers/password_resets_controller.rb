class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email:
      params[:password_reset][:email].downcase)
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = "Email sent with password reset instructions"
        redirect_to root_url
      else
        flash.now[:danger] = "Email address not found"
        render 'new'
      end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute( :reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
        render 'edit'
    end

  end
end

  def edit
  end
