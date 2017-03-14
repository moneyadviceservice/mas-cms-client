module Mas::Cms::Repository
  module Categories
    class CMS < Mas::Cms::Repository::Base
      def initialize(options = {})
        self.connection = Mas::Cms::Registry::Connection[:cms]
      end

      def all
        categories_url = '/api/%{locale}/categories.json' % { locale: I18n.locale }
        response = connection.get(categories_url)
        response.body
      rescue => e
        raise RequestError,
              'Unable to fetch Category JSON from Contento' +
              " url: [#{categories_url}]" +
              " error: [#{e.inspect}]" +
              " url_prefix: [#{connection.try(:url_prefix).inspect}]"
      end

      def find(id)
        response = connection.get('/api/%{locale}/categories/%{id}.json' %
                                    { locale: I18n.locale, id: id })

        if response.status == 301
          raise Mas::Cms::Repository::CMS::Resource301Error.new(response.headers['Location'])
        elsif response.status == 302
          raise Mas::Cms::Repository::CMS::Resource302Error.new(response.headers['Location'])
        end

        response.body
      rescue Mas::Cms::Repository::CMS::Resource301Error,
             Mas::Cms::Repository::CMS::Resource302Error => e
        raise e
      rescue
        raise RequestError, 'Unable to fetch Category JSON from Contento'
      end

      private

      attr_accessor :connection
    end
  end
end
