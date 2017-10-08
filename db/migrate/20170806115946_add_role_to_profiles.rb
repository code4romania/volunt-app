class AddRoleToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :role, :integer
  end
end
