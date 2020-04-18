class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
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

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filter

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Checl the expiration of reset-token.
  def check_expiration
    puts "!!! Params: #{params}"
    puts "!!! User: name=#{@user.name}, reset_digest=#{@user.reset_digest}"
    puts "!!! Expired: #{@user.password_reset_expired?}"
    puts "!!! Hashed #{ User.digest(params[:id])}"

    

    if @user.password_reset_expired? || !BCrypt::Password.new(@user.reset_digest).is_password?(params[:id])
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end