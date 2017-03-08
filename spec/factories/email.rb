FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :full_name do |n|
    Faker::Name.name
  end

  sequence :nick_name do |n|
    "user#{n}"
  end
end
