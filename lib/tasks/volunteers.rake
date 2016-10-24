require 'csv'

namespace :volunteers do
    PRENUME         = 0
    MIDDLE_NAME     = 1
    LAST_NAME       = 2
    PHOTO           = 3
    COMPANY         = 4
    WORK_EMAIL      = 5
    HOME_EMAIL      = 6
    OTHER_EMAIL     = 7
    CITY            = 8
    LINKEDIN        = 9
    PERSONAL_PAGE   = 10
    FACEBOOK_PAGE   = 11
    LIVEJOURNAL     = 12
    TWITTER         = 13
    OTHER_WEBSITE   = 14
    TIP             = 15
    POSITION        = 16
    SKILLS          = 17
    ID              = 18
    PROJECT         = 19
    NOTES           = 20

  desc 'List names, emails and location from csv'
  task :extract_names, [:filename] => :environment do |t, args|
    filename = args.key?(:filename) ? args[:filename] : Rails.root.join('lista_voluntari.csv')
    csv = CSV.parse(File.read(filename, headers: false))
    csv.each do |v|
        puts "#{v[LAST_NAME]} #{v[PRENUME]} #{v[MIDDLE_NAME]}, #{v[CITY]}, #{v[HOME_EMAIL]} #{v[WORK_EMAIL]} #{v[OTHER_EMAIL]}"
    end
  end
  
  desc 'Extract and normalizes skills from CSV'
  task :skills, [:filename] => :environment do |t, args|
    filename = args.key?(:filename) ? args[:filename] : Rails.root.join('lista_voluntari.csv')
    csv = CSV.parse(File.read(filename, headers: false))
    skills = []
    csv.each do |v|
      next if v[SKILLS].blank?
      s = normalize_skills(v[SKILLS])
      skills.push(*s)
    end
    skills.uniq.sort.each do |x|
      puts x
    end
  end

  desc 'Import .csv file'
  task :import, [:filename] => :environment do |t, args|
    filename = args.key?(:filename) ? args[:filename] : Rails.root.join('lista_voluntari.csv')
    csv = CSV.parse(File.read(filename, headers: false))
    csv.each do |v|
        attrs = {}
        attrs[:full_name] ="#{v[LAST_NAME]} #{v[PRENUME]} #{v[MIDDLE_NAME]}".strip
        if (!v[PRENUME].blank?)
          attrs[:nick_name] = v[PRENUME].strip
        elsif (!v[MIDDLE_NAME].blank?)
          attrs[:nick_name] = v[MIDDLE_NAME].strip
        elsif (!v[LAST_NAME].blank?)
          attrs[:nickname] = v[LAST_NAME].strip
        end

        if (!v[HOME_EMAIL].blank?)
          attrs[:email] = v[HOME_EMAIL].strip
        elsif (!v[WORK_EMAIL].blank?)
          attrs[:email] = v[WORK_EMAIL].strip
        elsif (!v[OTHER_EMAIL].blank?)
          attrs[:email] = v[OTHER_EMAIL].strip
        end

        if (attrs[:email].blank?)
          puts "Skipping blank email: #{v.inspect}"
          next
        end

        attrs[:contacts] = {email: attrs[:email]}
        attrs[:skills] = normalize_skills(v[SKILLS]) unless v[SKILLS].blank?
        attrs[:location] = v[CITY].strip unless v[CITY].blank?
        attrs[:photo] = v[PHOTO].strip unless v[PHOTO].blank?
        
        urls = {}
        urls[:linkedin] = v[LINKEDIN].strip unless v[LINKEDIN].blank?
        urls[:personal_page] = v[PERSONAL_PAGE].strip unless v[PERSONAL_PAGE].blank?
        urls[:facebook] = v[FACEBOOK_PAGE].strip unless v[FACEBOOK_PAGE].blank?
        urls[:livejournal] = v[LIVEJOURNAL].strip unless v[LIVEJOURNAL].blank?
        urls[:twitter] = v[TWITTER].strip unless v[TWITTER].blank?
        urls[:other] = v[OTHER_WEBSITE].strip unless v[OTHER_WEBSITE].blank?
        attrs[:urls] = urls unless urls.empty?
        attrs[:workplace] = v[COMPANY].strip unless v[COMPANY].blank?
        attrs[:title] = v[POSITION].strip unless v[COMPANY].blank?

        attrs[:flags] = Profile::PROFILE_FLAG_VOLUNTEER

        Profile.find_or_create_by(email: attrs[:email]) do |p|
          p.update(attrs)
          p.save
        end
        
    end
  end

  def normalize_skills(skills)
    skills.split(/\/|\,|\(|\)|\?|\&|\n+/).map do |x|
      x.strip.upcase
    end
  end

end
