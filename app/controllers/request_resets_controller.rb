class RequestResetsController < ApplicationController
  include SslConfig
  force_ssl only: [:show, :create], if: :ssl_configured?
  layout 'static'

  def show
    @request_reset_presenter = RequestResetPresenter.new
  end

  def create
    @request_reset_presenter = RequestResetPresenter.new params_permit
    redirected = false
    unless @request_reset_presenter.invalid?
      email = @request_reset_presenter.email
      notice = "Nu exista un profil pentru adresa de email #{email}"
      user = User.where(email: email).first
      if user.nil?
        # if the user doesn't exist but a profile claims this email, 
        # create an user on-the-fly. The email cannot login yet until
        # it prooves email ownership via the link
        profile = Profile.for_email email
        if profile
          user = User.create(email: email)
        end
      end
      unless user.nil?
        # rescue all exception to prevent leakage of account existance
        begin
          UserMailer.reset_password(user, email).deliver_now
          notice = 'Am trimis un email cu instructiuni de resetare a parolei'
          redirect_to login_path, notice: notice
          redirected = true
        rescue Exception => e
          Rails.logger.error "Exception in RequestResetsController::create: #{e.class.name}:  #{e.message}"
          notice = "Eroare la resetarea parolei pentru #{email}: #{e.message}"
        end
      end
    end
    flash.now[:notice] = notice
    render action: :show, status: :conflict unless redirected
  end

  private

  def params_permit
    params.fetch(:request_reset_presenter, {}).permit(:email)
  end
  
end


