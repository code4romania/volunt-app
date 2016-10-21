class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :full_name
      t.string :nick_name
      t.string :email
      t.json :contacts
      t.string :location
      t.string :photo
      t.string :curriculum
      t.text :description
      t.jsonb :urls
      t.string :title
      t.string :workplace
      t.string :tags, array: true
      t.string :skills, array: true

      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end
    add_index :profiles, :full_name
    add_index :profiles, :email, unique: true
    add_index :profiles, :skills, using: :gin
    add_index :profiles, :tags, using: :gin
  end
end
