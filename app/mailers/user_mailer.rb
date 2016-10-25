class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user)
    validation = ValidationToken.reset_password user
    @url = validation_token_url(validation)
    @user = user
    @to = @user.email
    mail(to: @user.email, subject: 'Reseteaza parola Voluntari Gov IT Hub')
  end
end
