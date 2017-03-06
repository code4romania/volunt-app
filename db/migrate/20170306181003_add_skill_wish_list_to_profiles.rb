class AddSkillWishListToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :skill_wish_list, :string, array: true
    add_index :profiles, :skill_wish_list, using: :gin
  end
end
