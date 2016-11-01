require 'csv'

namespace :community do

  full_name       = 0
  email           = 1
  location        = 2
  url             = 3
  photo           = 4

  desc 'Import community.csv from WP'
  task :import, [:filename] => :environment do |t, args|
    filename = args.key?(:filename) ? args[:filename] : Rails.root.join('comunitate.csv')

    # Try to coerce all names into 'familyname givenname' format

    # most common unambiguous family names form the data set
    common_names = ['Popa', 'Preda', 'Stan', 'Stoica', 'Costea', 'Oprea', 'Voicu', 'Ciobanu', 'Toma', 'Suciu', 'Barbu']

    # most common ambiguous names from the data set
    common_ambiguous = ['Constantin', 'Grigore', 'Radu', 'Tudor', 'Ion', 'Matei', 'David']

    # most common unambiguous given names from the data set
    common_surnames = ['Ionut', 'Ciprian', 'Mihai', 'Daniel', 'Florin', 'Dumitru', 'Adrian', 'Bogdan', 'Marius', 'Alexandru', 'Teodor',
            'Cristian', 'Mircea', 'Remus', 'Alex', 'Alin', 'Marian', 'Cosmin', 'Nicolae', 'Vasile', 'Silviu', 'Razvan', 'Marin',
            'Eugen', 'George', 'Andrei', 'Gabriel', 'Lucian', 'Vlad', 'Filip', 'Sebastian', 'Paul', 'Anca', 'Stefan', 'Calin', 'Octavian',
            'Catalin', 'Dan', 'Dragos', 'Emanuel', 'Andreea', 'Alina', 'Liviu', 'Robert', 'Iulian', 'Maria', 'Corina', 'Viorel',
            'Ovidiu', 'Costin', 'Emil', 'Laura', 'Raluca', 'Laurentiu', 'Gheorghe', 'Cezar', 'Victor', 'Sergiu', 'Roxana', 'Cristina',
            'Claudiu', 'Sorin', 'Eduard', 'Sandu', 'Ioana', 'Ioan', 'Daniela', 'Valentin', 'Mihaela', 'Serban', 'Mihail', 'Elena',
            'Oana', 'Narcis']

    # common family name endings
    name_patterns=/eanu\Z|escu\Z|ache\Z|oanu\Z|stea\Z|encu\Z|rlea\Z|ciuc\Z/i

    totals = {}

    CSV.foreach(filename, headers: true, col_sep: ',', encoding:'utf-8') do |row|
      if row[full_name].blank? or row[full_name].include? '_'
        totals[:bad] = (totals[:bad] || 0) + 1
        next 
      end

      if row[email].blank?
        totals[:noemail] = (totals[:noemail] || 0) + 1
        next
      end

      p = Profile.for_email(row[email])
      if !p.nil?
        totals[:existing] = (totals[:existing] || 0) + 1
        next
      end

      name_parts = row[full_name].split(' ').reject do |b| b.length == 1 end

      names = []
      surnames = []
      postponed = []
      
      name_parts.each do |n|
        if n =~ name_patterns
          names << n
        elsif common_names.include? n
          names << n
        elsif common_surnames.include? n
          surnames << n
        elsif common_ambiguous.include?(n) and surnames.length > 0 and names.length == 0
          names << n
        elsif common_ambiguous.include?(n) and surnames.length == 0 and names.length > 0
          surnames << n
        else
          postponed << n
        end
      end

      # here is where the rubber meets the road. 
      # 1) If we idendified an unambiguous family name and and one or more unambiguous given name, use them as such (ie. the easy case)
      # 2) If we identified one or more unambigous given names and one single unidentified name part, 
      #     then assume the unidentified part is the family name followed by given names(s)
      # 3) Otherwise, leave the name as is

      if names.length == 0 and surnames.length > 0 and postponed.length == 1
        names = postponed
        postponed = []
      end
  
      # for names with fairly high confidence in the correct match, fix the name order
      # Names with - are sorta kinda breaking stuff and there aren't many, leave them
      if (names.length == 1) and (name_parts[0] != names[0]) and !names[0].include? '-'
        name_parts.delete(names[0])
        name_parts = names.concat(name_parts)
        
        row[full_name] = name_parts.join(' ')
      end

      attrs = {full_name: row[full_name].titleize,
        email: row[email],
        location: row[location],
        photo: row[photo],
        urls_string: row[url],
        flags: Profile::PROFILE_FLAG_APPLICANT
        }
      if surnames.length > 0
        attrs[:nick_name] = surnames[0].titleize
      else
        attrs[:nick_name] = name_parts[-1].titleize
      end

      p = Profile.where(full_name: attrs[:full_name]).first
      if !p.nil?
        totals[:duplicate] = (totals[:duplicate] || 0) + 1
        puts "#{p.full_name} existent: #{p.email} importat: #{attrs[:email]}"
        next
      end

      p = Profile.create(attrs)
      if (!p.errors.empty?)
        totals[:errors] = (totals[:errors] || 0) + 1
        puts "#{p.errors.messages.inspect} #{attrs[:full_name]} #{attrs[:email]}"
      else
        totals[:created] = (totals[:created] || 0) + 1
      end

    end
    puts totals.inspect
  end

end
