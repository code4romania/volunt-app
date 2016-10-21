module FlagBitsConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def flag_bit(symbol, const = nil)

      if const.nil?
        const_name = name+"::"+"#{name}_FLAG_#{symbol}".upcase
        const = const_name.constantize
        Rails.logger.debug "Using const #{const} as #{const_name} for flag #{symbol}"
      end

      define_method("is_#{symbol}?") do
        (self.flags & const) != 0 ? true : false
      end
      define_method("is_#{symbol}=") do |value|
        self.flags &= ~const unless value
        self.flags |= const if value
      end
    end
  end

end
