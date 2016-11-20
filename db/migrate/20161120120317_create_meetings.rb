class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.string :location, null: false
      t.datetime :date, null: false
      t.string :duration
      t.string :atendees, array: true
      t.text :notes
      t.text :attn_coordinators

      t.timestamps
    end

    create_table :meetings_profiles, id: false do |t|
      t.references :meeting, foreign_key: true, null: false, index: true
      t.references :profile, foreign_key: true, null: false, index: true
    end
  end
end
