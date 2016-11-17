class StatusReport < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  STATUS_REPORT_STATUS_DRAFT = 0
  STATUS_REPORT_STATUS_PUBLISHED = 1

  array_field :tags

  belongs_to :project, optional: true
  belongs_to :profile, optional: true
  belongs_to :author, optional: true, class_name: 'Profile'

  validates :summary, presence: true
  validates :report_date, presence: true
  validate :project_or_profile_presence

  default_scope -> { order(report_date: :desc) }

  def is_published?
    self.status == STATUS_REPORT_STATUS_PUBLISHED
  end

  def is_draft?
    self.status == STATUS_REPORT_STATUS_DRAFT
  end

  scope :drafts, -> { where(status: STATUS_REPORT_STATUS_DRAFT) }
  scope :published, -> { where(status: STATUS_REPORT_STATUS_PUBLISHED) }

  def ref
    return self.project.name unless self.project.nil?
    return self.profile.full_name unless self.profile.nil?
    return ''
  end

  def self.last_for_profile(profile)
    where(profile: profile).order(report_date: :desc).first
  end

  def self.last_for_project(project)
    where(project: project).order(report_date: :desc).first
  end

  private

  def project_or_profile_presence
    if project.nil? and profile.nil?
      errors.add(:base, "Specify a profile or a project")
    end
  end
  
end
