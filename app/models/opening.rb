class Opening < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  array_field :tags
  array_field :skills

  validates :title, presence: :true

  belongs_to :project, required: false

  default_scope {order(publish_date: :desc)}

  scope :visible, -> {
      where(
        'publish_date <= :today and deadline >= :today',
        today: Date.today).
      order(publish_date: :desc) }

  def is_visible?
    return false if self.publish_date.nil? or self.deadline.nil?
    return (self.publish_date <= Date.today) || (self.deadline >= Date.today)
  end

  def contact_info
    return self.contact unless self.contact.blank?
    return self.project.owner.email unless self.project.nil? or self.project.owner.nil?
    return Rails.configuration.x.email.openings_contact unless Rails.configuration.x.email.openings_contact.nil?
    return Rails.configuration.x.email.from  unless Rails.configuration.x.email.from.nil?
    return 'Configuration error: no opening contact fallback'
  end

end
