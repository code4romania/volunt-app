class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :profile

  validates :role, presence: true
  validates :project_id, presence: true, uniqueness: {scope: :profile, message: 'is already assigned to this profile'}
  validates :profile_id, presence: true, uniqueness: {scope: :project, message: 'is already assigned to this project'}

  scope :volunteers, -> { joins(:profile).merge(Profile.volunteers) }
  scope :fellows, -> { joins(:profile).merge(Profile.fellows) }
end
