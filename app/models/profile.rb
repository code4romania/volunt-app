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

  has_many :status_reports, dependent: :delete_all

  def select_name
    "%-20s: %s" % [full_name, email]
  end

  def has_email?(some_email)
    return true if self.email.casecmp(some_email) == 0
    ["email", "email1", "email2", "email3"].each do |k|
      return true if self.contacts.has_key?(k) and 
        some_email.casecmp(self.contacts[k]) == 0
    end unless self.contacts.nil?
    return false
  end

  def self.for_email(email)
    # TODO: there is no :gin index on :contacts
    # Overall, I'm not happy with how we store emails. Needs refactoring
    sql = <<-SQL
      profiles.email ILIKE :email or 
      profiles.contacts::json->>'email' ILIKE :email or 
      profiles.contacts::json->>'email1' ILIKE :email or 
      profiles.contacts::json->>'email2' ILIKE :email or 
      profiles.contacts::json->>'email3' ILIKE :email
SQL
    self.where(sql,  email: email).first
  end

end
