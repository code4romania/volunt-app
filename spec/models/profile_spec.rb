require 'rails_helper'

describe Profile, type: :model do
  let(:profile) { create :profile }

  it 'is valid with valid attributes' do
    expect(profile).to be_valid
  end
end
