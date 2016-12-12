require 'rails_helper'

describe Opening, type: :model do
  let(:opening) { create :opening }

  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to belong_to :project }

  it 'is valid with valid attributes' do
    expect(opening).to be_valid
  end
end
