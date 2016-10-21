class LoginPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :email, :password
  validates :email, presence: true, email: true
  validates :password, presence: true
end
