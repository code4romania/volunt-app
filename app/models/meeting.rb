class Meeting < ApplicationRecord
  include TagsConcern
  array_field :atendees

  has_and_belongs_to_many :profiles
  validates :location, presence: true
  validates :date, presence: true

  default_scope {order(date: :desc)}

end
