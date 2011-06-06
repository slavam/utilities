class User < ActiveRecord::Base
  attr_accessor :current_password

  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

#  acts_as_audited :only => [:login, :email, :active]

  def admin?
    login == "admin"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end

  def deliver_new_user_instructions!
    reset_perishable_token!
    UserMailer.deliver_new_user_instructions(self)
  end
end
