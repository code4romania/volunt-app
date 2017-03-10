class RenamePasswordHash < ActiveRecord::Migration[5.0]
  def self.up
    rename_column :users, :password_hash, :password_digest

    User.find_each do |user|
      user.set_random_password
      user.save
    end
  end

  def self.down
    rename_column :users, :password_digest, :password_hash
  end
end
