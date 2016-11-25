namespace :cleanup do

  desc 'Trim profile string values which are too long'
  task profiles_with_long_strings: :environment do
    rules = {
      full_name: Profile::MAX_LENGTH_FULL_NAME,
      nick_name: Profile::MAX_LENGTH_NICK_NAME
    }

    rules.each_pair do |key, max_length|
      Profile.where("length(#{key}) > #{max_length}").each do |cheeky_profile|
        hash = {}
        hash[key] = cheeky_profile[key][0...max_length].strip
        cheeky_profile.update(hash)
      end
    end
  end
end
