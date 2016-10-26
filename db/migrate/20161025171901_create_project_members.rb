class CreateProjectMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :project_members do |t|
      t.string :role
      t.references :project, foreign_key: true, null: false
      t.references :profile, foreign_key: true, null: false
      t.integer :status, null: false, default: 0
      t.integer :flags, null: false, default: 0

      t.timestamps
    end
    
    # both (project, profile) and (profile, project) indices are required
    add_index :project_members, [:project_id, :profile_id], unique: true
    add_index :project_members, [:profile_id, :project_id], unique: true
  end
end
