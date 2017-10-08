FactoryGirl.define do
  factory :profile do
    user { create :user }
    full_name { generate :full_name }
    nick_name { generate :nick_name }
    email { generate :email }
    contacts_string { "email1: #{generate :email}" }
  end
end
