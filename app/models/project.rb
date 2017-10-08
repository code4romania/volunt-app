class Project < ApplicationRecord
  include TagsConcern

  array_field :tags
  hash_field :urls, urls: true, properties: Rails.configuration.x.project_urls.keys

  has_many :members, class_name: 'ProjectMember', dependent: :delete_all
  has_many :profiles, through: :members
  has_many :openings, dependent: :delete_all

  belongs_to :owner, class_name: 'Profile', required: false

  default_scope { order('name ASC') }

  def is_subscribed?(profile)
    members.where(profile_id: profile.id).exists?
  end

  def notify_members(opening)
    members.each do |member|
      begin
        UserMailer.new_opening(member.profile, self, opening).deliver
      rescue Exception => x
        Rails.logger.error("opening notify_members error: #{x.class.name}: #{x.message}")
        raise x if Rails.env.test?
      end
    end
  end
end
