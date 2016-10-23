class ResetPasswordPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :password, :password_confirmation

  validates :password, presence: true, confirmation: true
end
