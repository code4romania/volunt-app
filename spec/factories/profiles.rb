FactoryGirl.define do
  factory :profile do
    full_name
    nick_name
    email
    contacts_string {"email1: #{generate :email}"}
  end
end
