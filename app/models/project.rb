class Project < ApplicationRecord
  include TagsConcern
  include FlagBitsConcern

  array_field :tags

end
