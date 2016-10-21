class ProfileSearchPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :skills, :email, :full_name, :location

end
