class ProjectSearchPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :name

  def blank?
    name.blank?
  end
end
