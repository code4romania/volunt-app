class ProfileSearchPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :email, :full_name, :location, :attrs

  def blank?
    full_name.blank? and
    email.blank? and
    location.blank? and
    attrs.blank?
  end

end
