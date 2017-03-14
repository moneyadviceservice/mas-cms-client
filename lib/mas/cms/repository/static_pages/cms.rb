module Mas::Cms::Repository
  module StaticPages
    class Cms < Mas::Cms::Repository::Base
      def initialize
        self.connection = Mas::Cms::Registry::Connection[:cms]
      end

      def find(id)
        response = connection.get('/api/%{locale}/corporate/%{id}.json' %
                                    { locale: I18n.locale, id: id })

        attributes = response.body
        links      = response.headers['link'].try(:links) || []

        attributes['alternates'] = []
        links.each do |link|
          next unless link['rel'] == 'alternate'

          attributes['alternates'] << { url: link.href, title: link['title'], hreflang: link['hreflang'] }
        end

        attributes
      rescue Mas::Cms::Connection::Http::ResourceNotFound
        nil
      rescue Mas::Cms::Connection::Http::ConnectionFailed, Mas::Cms::Connection::Http::ClientError
        raise RequestError, 'Unable to fetch JSON from CMS'
      end

      private

      attr_accessor :connection
    end
  end
end
