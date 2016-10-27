class AddUrlsToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :urls, :jsonb, null: true
    add_column :projects, :owner_id, :integer, null: true
    add_index :projects, :owner_id
    add_index :projects, :urls, using: :gin
  end
end
