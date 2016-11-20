require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it 'is valid with valid attributes' do
    expect(FactoryGirl.create(:meeting)).to be_valid
  end
  it 'is invalid without a date' do
    expect(FactoryGirl.build(:meeting, date: nil)).to be_invalid
  end
  it 'is invalid without a location' do
    expect(FactoryGirl.build(:meeting, location: nil)).to be_invalid
  end
end
