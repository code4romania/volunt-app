class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.string :location, null: false
      t.string :agency, null: false
      t.datetime :date, null: false
      t.string :attendees, array: true
      t.string :summary
      t.text :notes
      t.text :attn_coordinators
      t.string :tags, array: true

      t.timestamps
    end

    add_index :meetings, :date, order: {date: :desc}

    create_table :meetings_profiles, id: false do |t|
      t.references :meeting, foreign_key: true, null: false, index: true
      t.references :profile, foreign_key: true, null: false, index: true
    end
  end
end
# TODO Delete this before going live, or else everyone will have to rebuild their DB