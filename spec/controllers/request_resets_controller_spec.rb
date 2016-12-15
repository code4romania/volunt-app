require 'rails_helper'

describe RequestResetsController, type: :controller do

  let!(:volunteer) { create(:volunteer) }
  let!(:profile)   { Profile.find_by_email(volunteer.email) }

  describe 'GET #show' do
    it 'renders :show' do
      get :show, {params: {protocol: 'https'} }
      expect(assigns(:request_reset_presenter)).to be_an_instance_of(RequestResetPresenter)
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    it 'creates validation_token for primary email' do
      expect do
        post :create, {params: {
            'request_reset_presenter' => {
              'email' => volunteer.email
            },
          'protocol' => 'https'
          }
        }
        expect(response).to redirect_to("/login")
      end.to change { ValidationToken.count }.from(0).to(1)
    end

    it 'creates validation_token for secondary email' do
      expect do
        post :create, {params: {
            'request_reset_presenter' => {
              'email' => profile.contacts["email1"]
            },
          'protocol' => 'https'
          }
        }
        expect(response).to redirect_to("/login")
      end.to change { ValidationToken.count }.from(0).to(1)
    end
    
    it 'does not create a validation_token for wrong email' do
      expect do
        post :create, {params: {
            'request_reset_presenter' => {
              'email' => generate(:email)
            },
          'protocol' => 'https'
          }
        }
        expect(response).to have_http_status(:conflict)
        expect(response).to render_template(:show)
      end.to_not change { ValidationToken.count }.from(0)
    end
  end

end
