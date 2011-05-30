class ResetPasswordsController < ApplicationController
  before_filter :require_no_user

  def send_link
    @user = User.new and return unless request.post?

    @user = User.find_by_email(params[:user][:email])
    unless @user
      @user = User.new
      @user.email = params[:user][:email]
      @user.errors.add(:email, :user_with_such_email_not_found) 
    else
      @user.deliver_password_reset_instructions!
      flash_notice 'send_link_notice'
      redirect_to root_url
    end
  end

  def reset
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash_error 'invalid_perishable_token'
      redirect_to root_url
      return
    end  

    return unless request.post?

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      notice_updated
      redirect_to profile_url
    end
  end
end

