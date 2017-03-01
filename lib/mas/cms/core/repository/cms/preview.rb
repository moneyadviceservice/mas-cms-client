module Mas::Cms::Repository
  module CMS
    class Preview < Mas::Cms::Repository::Base
      def initialize(_options = {})
        self.connection = Mas::Cms::Registry::Connection[:cms]
      end

      def find(id)
        response = connection.get('/api/preview/%{locale}/%{id}.json' % { id: id, locale: I18n.locale })
        AttributeBuilder.build(response)
      rescue Mas::Cms::Connection::Http::ResourceNotFound
        nil
      rescue Mas::Cms::Connection::Http::ConnectionFailed, Mas::Cms::Connection::Http::ClientError
        raise RequestError, 'Unable to fetch Article JSON from CMS'
      end

      private

      attr_accessor :connection
    end
  end
end
