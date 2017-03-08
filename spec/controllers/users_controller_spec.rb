require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:old_password) { "123" }
  let!(:user) { create(:user) }
  let(:session_data) {{"id" => user.id, "level" => LoginConcern::USER_LEVEL_NEWUSER}}

  before do
    session[:user_id] = session_data
  end

  context "GET change password" do
    it "works" do
      get :change_password
      expect(response).to be_success
    end
  end

  context "PUT set password" do
    let(:params) {
      {change_password_presenter: {old_password: old_password, password: "142", password_confirmation: "142"}}
    }

    it "works" do
      put :set_password, params: params
      expect(response).to redirect_to(me_path)
    end

    context 'when old password is wrong' do
      let(:old_password) {'xxop'}
      it "shows errors" do
        put :set_password, params: params
        expect(response).to be_success
        expect(response).to render_template('change_password')
      end
    end
  end
end
