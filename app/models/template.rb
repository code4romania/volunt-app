class Template < ApplicationRecord
  include FlagBitsConcern
  include TagsConcern

  validates :name, presence: true, uniqueness: true
  validates :subject, presence: true
  validates :body, presence: true

end
