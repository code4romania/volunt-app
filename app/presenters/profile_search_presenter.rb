class ProfileSearchPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :skills, :email, :full_name, :location

  def blank?
    full_name.blank? and
    email.blank? and
    location.blank? and
    skills.blank?
  end

end
