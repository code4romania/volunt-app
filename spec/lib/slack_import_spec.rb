require 'rails_helper'
require 'slack_import'

RSpec.describe SlackImport do
  context 'when creating new users' do
    let(:user_list) do
      [
        {
          "name" => "84colors",
          "is_admin" => false,
          "profile" => {
            "real_name" => "Cristiana Bardeanu",
            "title" => "UX, data visualization, front-end",
            "email" => "contact@colors.com"
          }
        },
        {
          "name" => "seven",
          "is_admin" => true,
          "profile" => {
            "real_name" => "Ion Bardeanu",
            "title" => "Ruby developer",
            "email" => "seven@colors.com"
          }
        },
        {
          "name" => "ace",
          "is_admin" => false,
          "is_bot" => true,
          "profile" => {
            "real_name" => "ace",
          }
        },
      ]
    end

    it 'works' do
      expect {
        service = SlackImport.new(user_list)
        service.import
      }.to change(User, :count).by(2)

      user_email = user_list.first["profile"]["email"]
      user = User.where(email: user_email).first
      expect(user).to be

      user_profile = Profile.where(email: user_email).first!
      expect(user_profile.full_name).to eq("Cristiana Bardeanu")
      expect(user_profile.nick_name).to eq("84colors")
      expect(user_profile.title).to eq("UX, data visualization, front-end")
      expect(user_profile.is_coordinator?).to eq(false)
      expect(user_profile.is_fellow?).to eq(false)
      expect(user_profile.is_volunteer?).to eq(true)

      admin_email = user_list[1]["profile"]["email"]
      user = User.where(email: admin_email).first
      expect(user).to be

      admin_profile = Profile.where(email: admin_email).first!
      expect(admin_profile.full_name).to eq("Ion Bardeanu")
      expect(admin_profile.nick_name).to eq("seven")
      expect(admin_profile.title).to eq("Ruby developer")
      expect(admin_profile.is_coordinator?).to eq(true)
      expect(admin_profile.is_fellow?).to eq(false)
      expect(admin_profile.is_volunteer?).to eq(true)
    end
  end
end
