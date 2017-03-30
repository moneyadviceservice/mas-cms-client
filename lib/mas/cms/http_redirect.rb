module Mas
  module Cms
    class HttpRedirect < RuntimeError
      STATUSES = [301, 302].freeze
      attr_reader :http_response

      class << self
        def redirect?(http_response)
          STATUSES.include?(http_response.status)
        end
      end

      def initialize(http_response)
        @http_response = http_response
        freeze
      end

      def location
        http_response.headers['Location']
      end
    end
  end
end
