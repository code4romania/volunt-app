FactoryGirl.define do
  factory :meeting do
    location "Somewhere"
    agency "Some ministry"
    date "2016-11-20"
    attendees ["Somebody"]
    summary "Short"
    notes "Novel"
    attn_coordinators "Whine"
    tags_string 'BUY LOW, SELL HIGH'
  end
end
