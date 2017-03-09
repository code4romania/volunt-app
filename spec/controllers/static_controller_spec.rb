require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  let(:email) { Faker::Internet.email }

  context "signup" do
    it "creates user" do
      post :signup, params: {signup_presenter: {email: email}}
      expect(response).to redirect_to(me_path)
      expect(User.where(email: email).first).to be
    end
  end
end
