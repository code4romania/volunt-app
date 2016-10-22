class Template < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  validates :subject, presence: true
  validates :body, presence: true

  def tags_string
    return tags.nil? ? '': tags.join(',')
  end

  def tags_string=(value)
    self.tags = value.split(/,|;|\//).map do |x|
      x.strip.upcase
    end.uniq
  end
end
