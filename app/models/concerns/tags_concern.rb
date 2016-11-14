require 'uri'

module  TagsConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def hash_field(field, opts={})
      define_method("#{field}_string") do
        val = send(field)
        return '' if val.nil?
        s = StringIO.new
        d = ''
        val.each do |k,v|
          s << "#{d}#{k}:#{v}"
          d = "\r"
        end
        return s.string
      end

      define_method("#{field}_string=") do |value|
        opts = opts.reverse_merge({
          upcase: false,
          strip: true,
          urls: false,
          delimiters: /,|;|\n|\r/
        })
        hash = value.split(opts[:delimiters]).inject({emails: 0, phones: 0, values: 0, accum: {}}) do |h, val|
          begin
            k,v = val.split(':', 2)
            k = k.strip unless k.nil?
            if !k.nil? and 
                  (k.casecmp('http') == 0 or k.casecmp('https') == 0)
                  and !v.blank?
                  and v.start_with? '//'
              # we've split an URL
              v = "#{k}:#{v}"
              k = nil
            elsif v.blank?
              # we have only value, no key
              v = k
              k = nil
            end
            
            # if key is missing, try to guess the value type
            if k.blank?
              if EmailValidator.valid?(v)
                h[:emails] += 1
                k = "email#{h[:emails]}"
              elsif /\A[\d\+\(\)\-\s\Z]+/.match(v.strip)
                h[:phones] += 1
                k = "phone#{h[:phones]}"
              elsif URI::regexp.match(v) or opts[:urls]
                v = "http://#{v.strip}" unless URI::regexp.match(v)
                uri = URI.parse(v)
                host = uri.host.sub(/\Aw+\./i,'').sub(/\.(com|ro|org)\Z/i,'')
                k = host
                i = 1
                while h[:accum].has_key? k
                  i += 1
                  k = "#{host}#{i}"
                end
              else
                h[:values] += 1
                k = "value#{h[:values]}"
              end
            end
    
            v = v.strip if opts[:strip]
            v = v.upcase if opts[:upcase]
            
            h[:accum][k.parameterize.underscore.to_sym] = v
          rescue Exception => e
            Rails.logger.error("hash_attribute assign parsing: #{e.class.name}: #{e.message}")
          end
          
          h
        end
        send("#{field}=", hash[:accum])
      end
    end

    def array_field(field, opts={})
      opts = opts.reverse_merge({
        upcase: true,
        strip: true,
        delimiters: /,|;|\/|\n|\r/
        })

      define_method("#{field}_string") do
        return send(field).nil? ? '': send(field).join(',')
      end

      define_method("#{field}_string=") do |value|
        arr = value.split(opts[:delimiters]).map do |x|
          x = x.strip if opts[:strip]
          x = x.upcase if opts[:upcase]
          x
        end.uniq
        self.send("#{field}=", arr)
        return self.send(field)
      end
    end
  end

end
