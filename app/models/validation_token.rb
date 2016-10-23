require 'securerandom'
require 'base64'

class ValidationToken < ActiveRecord::Base
  belongs_to :account, optional: true
  belongs_to :user, optional: true

  TOKEN_CATEGORY_EMAIL_CONFIRMATION = 1
  TOKEN_CATEGORY_PASSWORD_RESET = 2
  TOKEN_CATEGORY_INVITATION = 3

  def self.find_token(token)
    begin
      decoded = nil
      begin
        decoded  = Base64.urlsafe_decode64(token)
      rescue Exception => e
        Rails.logger.error "usrlsafe_decode64: #{token}: #{e.class}: #{e.message}"
      end
      if decoded.nil?
        # Is possible the mail client has stripped the terminal '=' or '=='
        begin
          decoded  = Base64.decode64(token)
        rescue Exception => e
          Rails.logger.error "decode64: #{token}: #{e.class}: #{e.message}"
        end
      end
      if (decoded.nil?)
        return nil
      end
      self.where(token: decoded).first
    rescue Exception => e
      Rails.logger.error "ValidationToken.find_token: #{e.class} #{e.message}"
      nil
    end
  end

  def is_reset_password?
    self.category == TOKEN_CATEGORY_PASSWORD_RESET
  end

  def is_confirm_email?
    self.category == TOKEN_CATEGORY_EMAIL_CONFIRMATION
  end

  def is_invitation?
    self.category == TOKEN_CATEGORY_INVITATION
  end

  def to_param
    token_base64
  end

  def token_base64
    Base64.urlsafe_encode64(self.token)
  end

  def self.confirm_email(user, force_new = false)
    last = self.where(user_id: user.id).where(category: TOKEN_CATEGORY_EMAIL_CONFIRMATION).last unless force_new
    return last unless last.nil?
    token = SecureRandom.hex 16 
    self.create(user: user, 
      category: TOKEN_CATEGORY_EMAIL_CONFIRMATION,
      token: token)
  end


  def self.reset_password(user)
    token = SecureRandom.hex 16
    self.create(user: user, 
      category: TOKEN_CATEGORY_PASSWORD_RESET,
      token: token)
  end

  def self.invite_user(user)
    token = SecureRandom.hex 16
    self.create(user: user, 
      category: TOKEN_CATEGORY_INVITATION,
      token: token)
  end

end
