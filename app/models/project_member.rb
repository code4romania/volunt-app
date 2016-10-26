class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :profile

  scope :volunteers, -> { joins(:profile).merge(Profile.volunteers) }
  scope :fellows, -> { joins(:profile).merge(Profile.fellows) }
end
