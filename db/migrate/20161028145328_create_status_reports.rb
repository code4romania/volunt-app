class CreateStatusReports < ActiveRecord::Migration[5.0]
  def change
    create_table :status_reports do |t|
      t.references :project, foreign_key: true, null: true
      t.references :profile, foreign_key: true, null: true
      t.datetime :report_date, null: false
      t.string :summary, null: false
      t.text :details
      t.string :tags, array: true
      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end

    add_index :status_reports, :tags, using: :gin

  end
end
