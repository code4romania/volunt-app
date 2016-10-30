class Project < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  array_field :tags
  hash_field :urls, urls: true

  has_many :members, class_name: 'ProjectMember', dependent: :delete_all
  has_many :profiles, through: :members
  has_many :status_reports, dependent: :delete_all
  
  belongs_to :owner, class_name: 'Profile'
end
