class Profile < ApplicationRecord
  include FlagBitsConcern
  include TagsConcern
  
  array_field :tags
  array_field :skills
  hash_field :urls, urls: true
  hash_field :contacts

  PROFILE_FLAG_APPLICANT    = 0x00000001
  PROFILE_FLAG_VOLUNTEER    = 0x00000002
  PROFILE_FLAG_FELLOW       = 0x00000004
  PROFILE_FLAG_COORDINATOR  = 0x00000008

  flag_bit :applicant
  flag_bit :volunteer
  flag_bit :fellow
  flag_bit :coordinator

  scope :volunteers, -> { where('profiles.flags & ? > 0', PROFILE_FLAG_VOLUNTEER) }
  scope :applicants, -> { where('profiles.flags & ? > 0', PROFILE_FLAG_APPLICANT) }
  scope :fellows, -> { where('profiles.flags & ? > 0', PROFILE_FLAG_FELLOW) }
  scope :coordinators, -> { where('profiles.flags & ? > 0', PROFILE_FLAG_COORDINATOR) }

  validates :full_name, presence: true, uniqueness: true
  validates :nick_name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  has_many :memberships, class_name: 'ProjectMember', dependent: :delete_all
  has_many :projects, through: :memberships

  def select_name
    "%-20s: %s" % [full_name, email]
  end

end
