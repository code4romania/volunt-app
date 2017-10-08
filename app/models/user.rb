class User < ApplicationRecord
  has_secure_password
  has_one :profile

  validates :email, uniqueness: {case_sensitive: false}, allow_nil: false, on: :create, email: :true

  def set_random_password
    self.password = (0...16).map { (65 + rand(26)).chr }.join
  end
end
