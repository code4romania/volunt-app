require 'rails_helper'

describe VolunteersController, type: :controller do
  def sign_in(user)
    session[:user_id] = {
      "id"    => user.id,
      "email" => user.email,
      "level" => LoginConcern::USER_LEVEL_NEWUSER
    }
  end

  before           { sign_in volunteer }
  let!(:volunteer) { create(:volunteer) }

  describe 'GET #new' do
    let(:profile)    { Profile.find_by_email(volunteer.email) }

    it 'sets profile flag and assigns profile with current email' do
      get :new, { params: { protocol: 'https' } }
      expect(profile.flags).to eq(volunteer.flags)
      expect(profile.email).to eq(volunteer.email)
      expect(assigns(:profile)).to be_an_instance_of(Profile)
      expect(assigns(:profile).email).to eq(volunteer.email)
      expect(response).to render_template('profiles/new')
    end
  end

  describe 'GET #show' do
    let(:profile)         { Profile.find_by_email(volunteer.email) }
    let(:project)         { create(:project) }
    let!(:memberships)    { profile.memberships = [create(:project_member, profile: profile, project: project)] }
    let!(:status_reports) { profile.status_reports = [create(:status_report, profile: profile, project: project)] }

    it 'assigns profile and project members' do
      get :show, { params: { id: volunteer.id, protocol: 'https' } }
      expect(assigns(:profile)).to eq(profile)
      expect(assigns(:memberships)).to eq(memberships)
      expect(assigns(:status_reports)).to eq(status_reports)
      expect(response).to render_template('profiles/me')
    end
  end
end
