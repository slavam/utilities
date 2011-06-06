class UserMailer < ActionMailer::Base
  def password_reset_instructions(user)
    setup user
    @subject = I18n.t 'mailer.subjects.password_reset_instructions'
    @body[:url] = reset_password_url(:id => user.perishable_token)
  end 

  def new_user_instructions(user)
    setup user

    @subject = I18n.t 'mailer.subjects.new_user_instructions'
    @body[:url] = reset_password_url(:id => user.perishable_token)
  end 

  def setup(user)
    @from = USER_MAILER_EMAIL
    @recipients = user.email
    @sent_on = Time.now
  end
end
