FactoryGirl.define do
  factory :opening do
    title "Opening"
    deadline	"2016-12-24"
    publish_date "2016-12-20"
    description "Some description"
    skills "Some skills"
    experience "Some experience"
    contact { generate(:email) }
    status 0
  end
end