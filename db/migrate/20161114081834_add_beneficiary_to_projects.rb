class AddBeneficiaryToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :beneficiary, :string
    add_column :projects, :objective, :text
  end
end
