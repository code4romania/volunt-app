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

end
