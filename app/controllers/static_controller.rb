class StaticController < ApplicationController
  include LoginConcern
  force_ssl only: [:login, :login_post, :password_reset]
  layout 'static'

  def home
    redirect_to is_user_logged_in? ? volunteers_path : login_path
  end

  def login
    @login_presenter = LoginPresenter.new
  end

  def login_post
    @login_presenter = LoginPresenter.new params.fetch(:login_presenter, {}).permit(:email, :password)
    user = nil
    if (@login_presenter.valid?)
      user = User.where(email: @login_presenter.email).first
    end
    if (user && user.is_password_match?(@login_presenter.password))
      login_user(user)
      redirect_to root_path
    else
      @login_presenter.errors.add(:email, :invalid, message: 'Invalid user name or password')
      render :login
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end
end
