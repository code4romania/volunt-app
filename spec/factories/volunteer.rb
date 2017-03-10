FactoryGirl.define do
  factory :volunteer, parent: :user do
    after(:create) do |volunteer|
      create(:profile, email: volunteer.email, flags: Profile::PROFILE_FLAG_VOLUNTEER)
    end
  end
end
