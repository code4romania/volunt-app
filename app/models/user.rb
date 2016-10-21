class User < ApplicationRecord
  include FlagBitsConcern

  attr_accessor :password, :password_confirmation
  validates :email, uniqueness: {case_sensitive: false}, allow_nil: false, on: :create, email: :true
  validates :password, presence: true, confirmation: true, if: :password_changed?
  
  before_save :digest_password_hash!, if: :password_changed?

  def is_password_match?(pwd)
    digest_password_hash! unless @password.nil?
    self.password_hash == get_ha1(pwd)
  end
  
  def password=(value)
    attribute_will_change!('password') if @password != value
    @password = value
  end
  
  def password_changed?
    changed.include?('password')
  end
  
  def self.http_digest_ha1(name, pwd)
    ::ActionController::HttpAuthentication::Digest.ha1(
      {
        username: name,
        realm: Rails.configuration.x.domains.digest
      },
      pwd)
  end
  
private

  def get_ha1(pwd)
    self.class.http_digest_ha1(self.email, pwd)
  end

  def digest_password_hash!
    self.password_hash = get_ha1(@password)
  end
end
