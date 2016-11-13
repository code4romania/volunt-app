class CreateOpenings < ActiveRecord::Migration[5.0]
  def change
    create_table :openings do |t|
      t.string :title, null: false
      t.datetime :deadline
      t.datetime :publish_date
      t.text :description
      t.string :skills, array: true
      t.string :tags, array: true
      t.references :project, null: true, foreign_key: true
      t.text :experience
      t.string :contact
      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end

    add_index :openings, :publish_date, order: {publish_date: :desc}
    add_index :openings, [:project_id, :publish_date], order: {project_id: :asc, publish_date: :desc}
    add_index :openings, :title
    add_index :openings, :tags, using: :gin
    add_index :openings, :skills, using: :gin

  end
end
