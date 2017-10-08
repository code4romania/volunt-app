require 'rails_helper'

RSpec.describe OpeningsController, type: :controller do
  let!(:admin) { create :user }
  let!(:admin_profile) { create(:profile, email: admin.email, flags: Profile::PROFILE_FLAG_VOLUNTEER) }

  let(:session_data) {{"id" => admin.id, "level" => LoginConcern::USER_LEVEL_COORDINATOR}}
  let!(:project) { create :project }
  let!(:user) { create :volunteer }
  let!(:member) { create :project_member, profile: user.profile, project: project }

  before do
    session[:user_id] = session_data
  end

  context "POST /create" do
    it "works" do
      post :create, params: {opening: {title: "New UI design"}, project_id: project.id}
      expect(response).to redirect_to(project_path(project))
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to include("New UI design")
    end
  end
end
