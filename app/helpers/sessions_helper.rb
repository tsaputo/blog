# frozen_string_literal: true

module SessionsHelper
  # User login
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns current user (if user exists)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Returns true, if user is logged in /else false.
  def logged_in?
    current_user != nil
  end

  # Log out of current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
