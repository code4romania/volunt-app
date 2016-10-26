require 'csv'

namespace :fellows do
  FELLOW_NUME        = 0
  FELLOW_PRENUME     = 1
  FELLOW_EMAIL_1     = 2
  FELLOW_EMAIL_2     = 3
  FELLOW_EMAIL_3     = 4
  FELLOW_PHONE_1     = 5
  FELLOW_PHONE_2     = 6
  FELLOW_SKILLS      = 8

  desc "Import fellows from csv"
  task :import, [:filename] => :environment do |t, args|

    filename = args.key?(:filename) ? args[:filename] : Rails.root.join('contacte-bursieri.csv')
    csv = CSV.parse(File.read(filename, headers: false))

    csv.each do |v|
      attrs = {
        full_name: "#{v[FELLOW_NUME]} #{v[FELLOW_PRENUME]}",
        nick_name: v[FELLOW_PRENUME],
        email: v[FELLOW_EMAIL_1],
        contacts: {
          phone: v[FELLOW_PHONE_1]
        }
      }

      unless v[FELLOW_SKILLS].blank?
        skills = normalize_skills(v[FELLOW_SKILLS])
        attrs[:skills] = skills
      end

      unless v[FELLOW_EMAIL_2].blank?
        attrs[:contacts][:email2] = v[FELLOW_EMAIL_2]
      end
        
      unless v[FELLOW_EMAIL_3].blank?
        attrs[:contacts][:email3] = v[FELLOW_EMAIL_3]
      end

      unless v[FELLOW_PHONE_2].blank?
        attrs[:contacts][:phone2] = v[FELLOW_PHONE_2]
      end

      Profile.find_or_create_by(email: attrs[:email]) do |p|
        p.update(attrs)
        p.is_fellow = true
        p.save
      end

      User.find_or_create_by(email: attrs[:email])

    end
  
  end
end
