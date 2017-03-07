FactoryGirl.define do
  factory :user do
    email { generate :email }
    password '123'
  end
end
