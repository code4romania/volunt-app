class Profile < ApplicationRecord
  include FlagBitsConcern
  include TagsConcern
  
  array_field :tags
  array_field :skills
  #array_field :urls, {upcase: false}

  PROFILE_FLAG_APPLICANT    = 0x00000001
  PROFILE_FLAG_VOLUNTEER    = 0x00000002
  PROFILE_FLAG_FELLOW       = 0x00000004
  PROFILE_FLAG_COORDINATOR  = 0x00000008

  flag_bit :applicant
  flag_bit :volunteer
  flag_bit :fellow
  flag_bit :coordinator

  validates :full_name, presence: true, uniqueness: true
  validates :nick_name, presence: true
  validates :email, presence: true, uniqueness: true, email: true

  scope :volunteers, -> { where('flags & ? > 0', PROFILE_FLAG_VOLUNTEER) }
  scope :applicants, -> { where('flags & ? > 0', PROFILE_FLAG_APPLICANT) }
  scope :fellows, -> { where('flags & ? > 0', PROFILE_FLAG_FELLOW) }
  scope :coordinators, -> { where('flags & ? > 0', PROFILE_FLAG_COORDINATOR) }

end
