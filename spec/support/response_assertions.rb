# Redefine assert_redirected_to to ignore http vs. https diff

module ActionDispatch
  module Assertions
    module ResponseAssertions

      alias_method :original_normalize_argument_to_redirection, :normalize_argument_to_redirection

      # Force all redirect asserts to normalize http
      # Otherwise we get bogus http vs. https failures
      def normalize_argument_to_redirection(fragment)
        r = original_normalize_argument_to_redirection(fragment)
        u = URI.parse(r)
        u.scheme = 'http'
        u.to_s
      end
    end
  end
end
