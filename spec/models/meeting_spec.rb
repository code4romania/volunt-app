require 'rails_helper'

RSpec.describe Meeting, type: :model do
  let(:meeting) { create :meeting }

  it 'is valid with valid attributes' do
    expect(meeting).to be_valid
  end

  it 'is invalid without a date' do
    expect(build(:meeting, date: nil)).to be_invalid
  end

  it 'is invalid without a location' do
    expect(build(:meeting, location: nil)).to be_invalid
  end
end
