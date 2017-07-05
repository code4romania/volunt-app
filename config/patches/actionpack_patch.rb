
module ActionController #:nodoc:
  module RequestForgeryProtection

    def verified_request? # :doc:

      puts "protect agains forgery: #{protect_against_forgery?}"
      puts "request get: #{request.get?}"
      puts "request get: #{request.head?}"
      puts "valid req origin: #{valid_request_origin?}"
      puts "any auth token:#{any_authenticity_token_valid?}"
      !protect_against_forgery? || request.get? || request.head? ||
          (valid_request_origin? && any_authenticity_token_valid?)
    end


  end
end