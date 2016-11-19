require 'rails_helper'

describe LoginConcern do
  before do
    class FakesController < ApplicationController
      include LoginConcern
      attr_accessor :session
    end
  end
  after { Object.send :remove_const, :FakesController }

  let(:profile) { build :profile }
  let(:object) {
    fake = FakesController.new
    fake.session = {}
    fake
  }

  it 'gives asscess to the session attr' do
    expect(object.session).to eq({})
    object.session[:user_id] = 1
    expect(object.session[:user_id]).to eq 1
  end

  describe 'is_user_logged_in?' do
    it 'checks for user_id presence in the session' do
      expect(object).to_not be_is_user_logged_in
      object.session[:user_id] = {}
      expect(object).to be_is_user_logged_in
    end
  end

  describe 'current_user_email' do
    let(:test_email) { 'hello@hello.com' }

    it 'works' do
      object.session[:user_id] = { 'email' => test_email }
      expect(object.current_user_email).to eq test_email
    end
  end

  describe 'ensure_user_is_logged_in' do
    it 'raises LoginConcernException if user is not logged in' do
      expect {
        object.ensure_user_is_logged_in
      }.to raise_error LoginConcernException
    end

    it 'does not raise LoginConcernException if user is logged in' do
      expect {
        object.session[:user_id] = {}
        object.ensure_user_is_logged_in
      }.to_not raise_error
    end
  end

  describe 'current_user_profile' do
    it 'returns the profile from session[:user_id]["profile_id"]' do
      object.session[:user_id] = { 'profile_id' => 1 }
      expect(Profile).to receive(:find).and_return profile
      expect(object).to receive(:current_user_email).and_return profile.email
      expect(object.current_user_profile).to eq profile
    end
  end
end
