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
  let!(:profile)   { Profile.find_by_email(volunteer.email) }

  describe 'GET #new' do
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

  describe 'PUT #update' do
    let(:full_name) { 'Nume plin' }

    it 'updates the profile' do
      put :update, { params: {
        'id'      => volunteer.id,
        'profile' => {
          'full_name'          => full_name,
          'nick_name'          => 'Porecla',
          'photo'              => '',
          'email'              => 'imeil@igzemple.com',
          'contacts_string'    => '',
          'location'           => 'Romania',
          'title'              => 'Manager',
          'workplace'          => 'Guvernul României',
          'skills_string'      => 'Ruby',
          'urls_string'        => '',
          'description'        => 'descriere',
          'tags_string'        => 'remote',
          'hidden_tags_string' => 'nda'
        },
        'protocol' => 'https'
      }
    }

      expect(assigns(:profile)).to eq(profile)
      expect(assigns(:profile).full_name).to eq(full_name)
      expect(assigns(:profile).hidden_tags).to eq(['SELF UPDATED'])
      expect(response).to redirect_to("/volunteers/#{volunteer.id}")
    end
  end
end
