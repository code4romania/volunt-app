class Meeting < ApplicationRecord
  include TagsConcern
  array_field :tags
  array_field :attendees

  has_and_belongs_to_many :profiles, unique: true
  accepts_nested_attributes_for :profiles
  validates :location, presence: true
  validates :date, presence: true
  
  default_scope {order(date: :desc)}

end
