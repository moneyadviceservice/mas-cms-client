module Mas::Cms::Repository
  module CMS
    class ResourceElsewhereError < Exception
      attr_reader :location

      def initialize(msg, location)
        super(msg)
        @location = location
      end

      def status
        raise NotImplementedError
      end
    end

    class Resource301Error < ResourceElsewhereError
      def initialize(location)
        super(self.class, location)
      end

      def status
        301
      end
    end

    class Resource302Error < ResourceElsewhereError
      def initialize(location)
        super(self.class, location)
      end

      def status
        302
      end
    end

    class CMS < Mas::Cms::Repository::Base
      def initialize(options = {})
        self.connection = Mas::Cms::Registry::Connection[:cms]
      end

      def find(id)
        response = connection.get(resource_url(id))

        if response.status == 301
          raise Mas::Cms::Repository::CMS::Resource301Error.new(response.headers['Location'])
        elsif response.status == 302
          raise Mas::Cms::Repository::CMS::Resource302Error.new(response.headers['Location'])
        end

        process_response(response)
      rescue Mas::Cms::Connection::Http::ResourceNotFound
        nil
      rescue Mas::Cms::Repository::CMS::Resource301Error,
             Mas::Cms::Repository::CMS::Resource302Error => e
        raise e
      rescue => e
        raise RequestError, 'Unable to fetch Article JSON from Contento'
      end

      def resource_name
        self.class.name.split('::')[-2].underscore
      end

      private

      def process_response(response)
        AttributeBuilder.build(response)
      end

      def resource_url(id)
        '/api/%{locale}/%{page_type}/%{id}.json' % { locale: I18n.locale, page_type: resource_name, id: id }
      end

      attr_accessor :connection
    end
  end
end
