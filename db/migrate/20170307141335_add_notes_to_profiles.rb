class AddNotesToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :notes, :text
  end
end
