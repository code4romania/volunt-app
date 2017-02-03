class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password.subject
  #
  def reset_password(user, email = nil)
    validation = ValidationToken.reset_password user
    @url = validation_token_url(validation)
    @user = user
    @to = email || @user.email
    mail(to: @to, subject: 'Reseteaza parola Voluntari Code4Romania')
  end

  def welcome(user)
    validation = ValidationToken.reset_password user
    @url = validation_token_url(validation)
    @user = user
    @to = @user.email
    mail(to: @user.email, subject: 'Bine ai venit in comunitatea Code4Romania')
  end
end
