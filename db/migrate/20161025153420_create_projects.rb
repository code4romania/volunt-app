class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.string :tags, array: true
      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end
    add_index :projects, :name, unique: true
    add_index :projects, :tags, using: :gin
  end
end
