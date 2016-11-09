class StaticController < ApplicationController
  include LoginConcern
  include SslConfig
  force_ssl only: [:home, :signup, :signup_post, :login, :login_post, :password_reset], if: :ssl_configured?
  layout 'static'

  def home
    if is_user_logged_in?
      flash.keep(:notice)
      redirect_to me_path
    end
    @signup_presenter = SignupPresenter.new
  end

  def signup
    @signup_presenter = SignupPresenter.new params.fetch(:signup_presenter, {}).permit(:email)

    if !@signup_presenter.valid?
      render :home
      return
    end

    user = User.find_by(email: @signup_presenter.email)
    if user
      @login_presenter = LoginPresenter.new email: @signup_presenter.email
      flash[:notice] = "Exista deja un cont pentru #{@signup_presenter.email}"
      render :login
      return
    end

    # Try to create the user
    user = User.create(email: @signup_presenter.email)
    if !user.valid?
      render :home
      return
    end

    begin
      UserMailer.welcome(user).deliver_now
    rescue Exception=>x
      Rails.logger.error("signup: #{x.class.name}: #{x.message}")
    end

    # Locate the profile. If the email already has a profile, the user must first
    # confirm the email address before being allowed into the site.
    # Since he can edit its own profile, he must first proove control of the email

    profile = Profile.for_email(user.email)
    if profile
      logout_user
      render 'confirm_email'
    else
      # No existing profile.Allow the user in.
      # me_path will automatically redirect him to applicants/new
      # strictly speaking there is a race condition here, as a profile
      # could had been created since we checked, before the redirect. Not worth bother.
      login_user(user)
      redirect_to me_path, notice: "Contul #{@signup_presenter.email} a fost creat."
    end
  end

  def login
    logout_user
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

  def impersonate
    notice = 'Not found'
    if Rails.env.development?
      p = Profile.for_email(params[:email])
      if p
        logout_user
        user = User.find_or_create_by(email: params[:email])
        login_user(user)
        notice = "You have impersonated user: #{user.id}: #{user.email}: at level: #{current_user_level}"
      end
    end
    redirect_to root_path, notice: notice
  end
end
