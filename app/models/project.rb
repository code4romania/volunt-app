class Project < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  array_field :tags
  hash_field :urls, urls: true, properties: Rails.configuration.x.project_urls.keys

  has_many :members, class_name: 'ProjectMember', dependent: :delete_all
  has_many :profiles, through: :members
  has_many :status_reports, dependent: :delete_all
  has_many :openings, dependent: :delete_all
  
  belongs_to :owner, class_name: 'Profile', required: false
  
  default_scope { order('name ASC') }

  def is_subscribed?(profile)
    members.where(profile_id: profile.id).exists?
  end
end
