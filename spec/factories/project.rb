FactoryGirl.define do
  factory :project do
    sequence :name do |n|
      "Proiect #{n}"
    end
  end
end
