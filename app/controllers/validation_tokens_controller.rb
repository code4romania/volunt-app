require 'base64'

class ValidationTokensController < ApplicationController
  include ActiveSupport::Callbacks
  helper_method :reset_password_presenters_path
  before_action :find_token
  define_callbacks :confirm_user_email
  layout 'static'

  def show
    # Any link that is clicked is actually a valid user email confirmation
#    if !@token.user.nil?
#      User.transaction do
#        run_callbacks :confirm_user_email do
#          if !@token.user.is_email_confirmed?
#            @token.user.is_email_confirmed = true
#            @token.user.save!
#          end
#        end
#      end
#    end

    if @token.is_reset_password?
      @reset_password_presenter = ResetPasswordPresenter.new
      render :reset_password
    elsif @token.is_confirm_email?
      render :confirm_email
    elsif @token.is_invitation?
      render :confirm_invitation
    end
  end

  def update
    if @token.is_reset_password?
      @reset_password_presenter = ResetPasswordPresenter.new reset_password_params
      if @reset_password_presenter.invalid?
        render :reset_password, status: :conflict
      else
        user = @token.user
        user.password = @reset_password_presenter.password
        user.password_confirmation = @reset_password_presenter.password_confirmation
        if user.save
          render :password_updated
        else
          @reset_password_presenter.errors << user.errors
          render :reset_password, status: :conflict
        end
      end
    else
      render :unknown, status: :conflict
    end
    
  end

  def reset_password_presenters_path
    validation_token_path(@token)
  end

  private

  def reset_password_params
    params.fetch(:reset_password_presenter, {}).permit(
      :password,
      :password_confirmation)
  end

  def find_token
    @token = ValidationToken.find_token(params[:id])
    if @token.nil?
      render :unknown, status: :not_found
    end
  end

end
