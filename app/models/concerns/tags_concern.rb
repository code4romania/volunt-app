module  TagsConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def array_field(field, opts={})
      opts = opts.reverse_merge({
        upcase: true,
        strip: true,
        delimiters: /,|;|\/|\n|\r/
        });

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
