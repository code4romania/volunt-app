class Profile < ApplicationRecord
  include TagsConcern

  #labels role: coordinator, label:coordinator
  # role :volunteer , label: techlead / communicate lead / ux lead
  belongs_to :user

  array_field :tags
  array_field :skills
  array_field :skill_wish_list
  array_field :hidden_tags
  hash_field :urls, urls: true
  hash_field :contacts

  enum role: {
      applicant: 0,
      volunteer: 1,
      coordinator: 2,
      hr: 3,
      admin: 4
  }

  self.roles.each do |role, enum_value|
    define_method("is_#{role}?") do
      self.try(role + '?')
    end
    define_method("is_#{role}=") do |value|
      self.role = role if value
    end
  end

  attr_accessor :political_affiliation
  attr_accessor :read_code_of_conduct

  MAX_LENGTH_FULL_NAME = 128
  MAX_LENGTH_NICK_NAME = 50

  scope :volunteers, -> { volunteer }
  scope :coordinators, -> { coordinator }
  scope :admins, -> { admin }
  scope :hrs, -> { hr }

  validates :full_name, presence: true, length: { maximum: MAX_LENGTH_FULL_NAME }
  validates :nick_name, presence: true, length: { maximum: MAX_LENGTH_NICK_NAME }
  validates :email, presence: true, uniqueness: true, email: true
  validates :political_affiliation, acceptance: true, on: :create
  validates :read_code_of_conduct, acceptance: true, on: :create

  has_many :memberships, class_name: 'ProjectMember', dependent: :delete_all
  has_many :projects, through: :memberships
  has_many :lead_projects, foreign_key: 'owner', class_name: 'Project'

  default_scope { order('full_name ASC') }

  def self.policy_class

  end

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
