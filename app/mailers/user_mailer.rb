class UserMailer < ApplicationMailer

   default from: "postmaster@sandboxa3e786773d9045a99c62bea6565cc1e9.mailgun.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
