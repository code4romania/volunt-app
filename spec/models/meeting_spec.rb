require 'rails_helper'

RSpec.describe Meeting, type: :model do
  let(:meeting) { create :meeting }

  it { is_expected.to validate_presence_of(:location) }
  it { is_expected.to validate_presence_of(:agency) }
  it { is_expected.to validate_presence_of(:date) }

  it 'is valid with valid attributes' do
    expect(meeting).to be_valid
  end
end
