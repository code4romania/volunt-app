class AddUserIdToProfile < ActiveRecord::Migration[5.1]
  def change
    add_reference :profiles, :user, foreign_key: true
    User.all.each do |u|
      profile = Profile.for_email(u.email)
      profile.update_attribute(:user_id, u.id) if profile.present?
    end
  end
end
