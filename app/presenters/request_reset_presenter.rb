class RequestResetPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :email
  validates :email, presence: true, email: true
end

