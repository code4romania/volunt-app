require 'rails_helper'

describe Profile, type: :model do
  let(:profile) { create :profile }

  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to validate_presence_of(:nick_name) }
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_uniqueness_of(:email) }

  it { is_expected.to have_many :memberships }
  it { is_expected.to have_many :projects }
  it { is_expected.to have_many(:lead_projects).class_name('Project')
       .with_foreign_key('owner') }
  it { is_expected.to have_many :status_reports }

  it { is_expected.to have_and_belong_to_many :meetings }

  it 'is valid with valid attributes' do
    expect(profile).to be_valid
  end
end
