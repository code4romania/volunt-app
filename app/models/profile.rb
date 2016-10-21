class Profile < ApplicationRecord
  include FlagBitsConcern

  PROFILE_FLAG_APPLICANT    = 0x00000001
  PROFILE_FLAG_VOLUNTEER    = 0x00000002
  PROFILE_FLAG_FELLOW       = 0x00000004
  PROFILE_FLAG_COORDINATOR  = 0x00000008

  flag_bit :applicant
  flag_bit :volunteer
  flag_bit :fellow
  flag_bit :coordinator

  scope :volunteers, -> { where('flags & ? > 0', PROFILE_FLAG_VOLUNTEER) }
  scope :applicants, -> { where('flags & ? > 0', PROFILE_FLAG_APPLICANT) }

end
