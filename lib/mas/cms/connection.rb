require 'faraday'

module Mas
  module Cms
    class Connection
      attr_reader :raw_connection

      Error = Class.new(StandardError) do
        attr_reader :original

        def initialize(original = $ERROR_INFO)
          super
          @original = original
        end
      end

      ClientError         = Class.new(Error)
      ConnectionFailed    = Class.new(Error)
      ResourceNotFound    = Class.new(Error)
      UnprocessableEntity = Class.new(Error)

      def initialize
        @raw_connection = Faraday.new(http_options) do |faraday|
          faraday.request :json
          faraday.request :retry, max: config.retries
          faraday.request :user_agent, app: 'Mas-Cms-Client', version: Mas::Cms::Client::VERSION
          faraday.response :raise_error
          faraday.response :json
          faraday.use :instrumentation
          faraday.adapter Faraday.default_adapter
        end
      end

      def get(*args)
        raw_connection.get(*args)

      rescue Faraday::Error::ResourceNotFound
        raise ResourceNotFound

      rescue Faraday::Error::ConnectionFailed
        raise ConnectionFailed

      rescue Faraday::Error::ClientError
        raise ClientError
      end

      def post(*args)
        raw_connection.post(*args)

      rescue Faraday::Error::ConnectionFailed
        raise ConnectionFailed

      rescue Faraday::Error::ClientError => error
        case error.response[:status]
        when 422
          raise UnprocessableEntity
        else
          raise ClientError
        end
      end

      private

      def http_options
        {
          url: config.host,
          request: {
            timeout: config.timeout,
            open_timeout: config.open_timeout
          }
        }
      end

      def config
        Mas::Cms::Client.config
      end
    end
  end
end
