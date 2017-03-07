class ProfileSearchPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :email, :full_name, :location, :attrs, :skill_wish_list

  def blank?
    full_name.blank? and
      email.blank? and
      location.blank? and
      skill_wish_list.blank? and
      attrs.blank?
  end

  def attrs_tags
    split_tags(attrs)
  end

  def skill_wish_list_tags
    split_tags(skill_wish_list)
  end

  private

  def split_tags(value)
    value.split(/\,|;/).map { |x| x.strip.upcase }
  end

end
