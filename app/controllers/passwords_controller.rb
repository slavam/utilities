class PasswordsController < ApplicationController
  before_filter :require_user

  def edit
  end

  def update
    @current_user.password = params[:user][:password]
    @current_user.password_confirmation = params[:user][:password_confirmation]

    unless @current_user.valid_password?(params[:user][:current_password])
      @current_user.errors.add(:current_password)
      render :edit
      return
    end

    if not @current_user.save
      render :edit
    else
      notice_updated
      redirect_to profile_path
    end
  end
end 

