class UserMailer < ApplicationMailer
  default from: 'no-reply@api.com'

  def welcome_email
    @user = params[:user]
    @url = new_user_session_url
    mail(to: @user.email, subject: t('api.emails.welcome_message.subject'))
  end
end
