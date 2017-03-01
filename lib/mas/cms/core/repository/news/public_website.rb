module Mas::Cms::Repository
  module News
    class PublicWebsite < Mas::Cms::Repository::Base
      def initialize
        self.connection = Mas::Cms::Registry::Connection[:public_website]
      end

      def find(id)
        response = connection.get('/%{locale}/news/%{id}.json' %
                                    { locale: I18n.locale, id: URI.encode(id) })
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
        raise RequestError, 'Unable to fetch News JSON from Public Website'
      end

      def all(options = {})
        response = connection.get('/%{locale}/news.json?page_number=%{page}&limit=%{limit}' %
                                  { locale: I18n.locale, page: options[:page], limit: options[:limit] })
        response.body
      rescue
        raise RequestError, 'Unable to fetch News JSON from Public Website'
      end

      private

      attr_accessor :connection
    end
  end
end
