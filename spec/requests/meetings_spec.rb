require 'rails_helper'

RSpec.describe "Meetings", type: :request do
  include RequestLoginConcern

  https = {params: {'HTTPS': 'on'}}

  def get_helpers(meeting, &block)
    [meetings_path, new_meeting_path, meeting_path(meeting), edit_meeting_path(meeting)].each do |url|
      yield url
    end
  end

    meeting = FactoryGirl.create(:meeting)
    context 'fellow' do
      before do
        login :fellow
      end
      it "can GET" do
        get_helpers(meeting) do |url|
          get url, https
          expect(response).to have_http_status(:success)
        end
      end
      it "can DELETE" do
        expect {
          delete meeting_path(meeting), https
          expect(response).to redirect_to(meetings_path)
        }.to change(Meeting, :count).by(-1)
      end
      it "can POST" do
        expect {
          attrs = {params: {
            meeting_presenter: {
              meeting: FactoryGirl.build(:meeting).attributes
            },
            'HTTPS': 'on'}}
          post meetings_path, attrs
          expect(response).to redirect_to(meeting_path(assigns(:meeting_presenter).meeting))
        }.to change(Meeting, :count).by(1)
      end
    end
    context 'volunteer' do
      before do
        login :volunteer
      end
      it 'cannot GET' do
        get_helpers(meeting) do |url|
          # must re-login for each case
          login :volunteer
          get url, https
          expect(response).to redirect_to(login_path)
        end
      end
      it 'cannot DELETE' do 
        expect {
          delete meeting_path(meeting), https
          expect(response).to redirect_to(login_path)
        }.not_to change(Meeting, :count)
      end
      it "cannot POST" do
        expect {
          post meetings_path, https
          expect(response).to redirect_to(login_path)
        }.not_to change(Meeting, :count)
      end
    end
end
