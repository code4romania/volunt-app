FactoryGirl.define do
  factory :volunteer, parent: :user do
    after(:create) do |volunteer|
      create(:profile, email: volunteer.email, role: :volunteer)
    end
  end
end
