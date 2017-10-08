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
      expect(profile.email).to eq(volunteer.email)
      expect(assigns(:profile)).to be_an_instance_of(Profile)
      expect(assigns(:profile).email).to eq(volunteer.email)
      expect(response).to render_template('profiles/new')
    end
  end

  describe 'GET #show' do
    let(:project)         { create(:project) }
    let!(:memberships)    { profile.memberships = [create(:project_member, profile: profile, project: project)] }

    it 'assigns profile and project members' do
      get :show, { params: { id: volunteer.profile.id, protocol: 'https' } }
      expect(assigns(:profile)).to eq(profile)
      expect(assigns(:memberships)).to eq(memberships)
      expect(response).to render_template('profiles/me')
    end
  end

  describe 'PUT #update' do
    let(:full_name) { 'Nume plin' }

    it 'updates the profile' do
      put :update, { params: {
        'id'      => volunteer.profile.id,
        'profile' => {
          'full_name'          => full_name,
          'nick_name'          => 'Porecla',
          'photo'              => '',
          'email'              => 'imeil@igzemple.com',
          'contacts_string'    => '',
          'location'           => 'Romania',
          'title'              => 'Manager',
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
      expect(response).to redirect_to("/volunteers/#{volunteer.profile.id}")
    end
  end

  describe 'POST #create' do
    let(:new_profile) { build_stubbed(:profile, email: 'new@volunteers.org') }

    before { profile.destroy! }

    it 'updates the profile' do
      expect do
        post :create, { params: {
          'profile' => {
            'full_name'          => new_profile.full_name,
            'nick_name'          => new_profile.nick_name,
            'photo'              => new_profile.photo,
            'email'              => new_profile.email,
            'contacts_string'    => new_profile.contacts_string,
            'location'           => new_profile.location,
            'title'              => new_profile.title,
            'skills_string'      => new_profile.skills_string,
            'urls_string'        => new_profile.urls_string,
            'description'        => new_profile.description,
            'tags_string'        => new_profile.tags_string,
            'hidden_tags_string' => new_profile.hidden_tags_string
          },
          'protocol' => 'https'
        }
      }
      end.to change { Profile.count }.from(0).to(1)
    end
  end
end
