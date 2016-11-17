class AddHiddenTagsToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :hidden_tags, :string, array: true
    add_index :profiles, :hidden_tags, using: :gin
  end
end
