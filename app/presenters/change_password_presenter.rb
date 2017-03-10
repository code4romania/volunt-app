class ChangePasswordPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :password, :password_confirmation, :old_password, :user
  validates :old_password, presence: true
  validates :password, confirmation: true, presence: true

  validate :check_old_password

  def check_old_password
    unless user.authenticate(old_password)
      errors.add(:old_password, "Parola veche este incorectă")
    end
  end
end
