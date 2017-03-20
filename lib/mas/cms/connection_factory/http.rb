require 'faraday/conductivity'

module Mas::Cms
  module ConnectionFactory
    class Http
      TIMEOUT = ENV.fetch('FRONTEND_HTTP_REQUEST_TIMEOUT').to_i

      def self.build(url, timeout: TIMEOUT, open_timeout: TIMEOUT, retries: 2)
#        Mas::Cms::Connection::Http.new(connection)
      end
    end
  end
end
