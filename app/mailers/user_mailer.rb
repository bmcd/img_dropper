class UserMailer < ActionMailer::Base
  default from: "no-reply@imgdropper.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user, token)
    @user = user
    @token = token
    mail to: user.email, subject: "Password Reset"
  end
end
