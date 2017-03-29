require 'faraday'
require 'faraday_middleware'
require 'faraday/conductivity'
require_relative 'http_redirect'
require_relative './errors/base'
Dir[File.join(File.dirname(__FILE__), 'errors/*.rb')].each { |f| puts f;  require f }

module Mas
  module Cms
    class Connection
      attr_reader :raw_connection, :cache

      def initialize(cache = Mas::Cms::Client.config.cache)
        @raw_connection = Faraday.new(http_options) do |faraday|
          faraday.request :json
          faraday.request :retry, max: config.retries
          faraday.request :user_agent, app: 'Mas-Cms-Client', version: Mas::Cms::Client::VERSION
          faraday.response :raise_error
          faraday.response :json
          faraday.use :instrumentation
          faraday.token_auth config.api_token
          faraday.adapter Faraday.default_adapter
        end
        @cache = cache
      end

      def get(path, cached: Mas::Cms::Client.config.cache_gets)
        with_exception_support do
          request = -> (_) { raw_connection.get(path) }
          response = (cache && !!cached ? cache.fetch(path, &request) : request[path])

          raise HttpRedirect.new(response) if HttpRedirect.is_redirect?(response)
          response
        end
      end

      def post(*args)
        with_exception_support { raw_connection.post(*args) }
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

      def with_exception_support(&blk)
        blk.call
      rescue Faraday::Error::ResourceNotFound
        raise Errors::ResourceNotFound

      rescue Faraday::Error::ConnectionFailed
        raise Errors::ConnectionFailed

      rescue Faraday::Error::ClientError => error
        case error.response[:status]
        when 422
          raise Errors::UnprocessableEntity
        else
          raise Errors::ClientError
        end
      end
    end
  end
end
