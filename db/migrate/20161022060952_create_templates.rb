class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.string :subject
      t.text :body
      t.string :tags, null: true, array: true
      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end
    add_index :templates, :name, unique: true
    add_index :templates, :tags, using: :gin
  end
end
