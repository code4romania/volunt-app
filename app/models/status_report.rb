class StatusReport < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  array_field :tags

  belongs_to :project, optional: true
  belongs_to :profile, optional: true

  validates :summary, presence: true
  validates :report_date, presence: true
  validate :project_or_profile_presence

  default_scope -> { order(report_date: :desc) }

  def ref
    return self.project.name unless self.project.nil?
    return self.profile.full_name unless self.profile.nil?
    return ''
  end

  private

  def project_or_profile_presence
    if project.nil? and profile.nil?
      errors.add(:base, "Specify a profile or a project")
    end
  end
  
end
