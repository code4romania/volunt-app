FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :full_name do |n|
    "Nelu Omăț#{n}"
  end

  sequence :nick_name do |n|
    "Neluțu#{n}"
  end
end
