module Mas
  module Cms
    module Resource
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def find(slug:, locale: 'en')
          new(
            slug,
            http.get(path(slug: slug, locale: locale))
          )
        end

        def all(locale: 'en')
          http.get(path(slug: nil, locale: locale)).map do |entity_attrs|
            new(
              entity_attrs.delete(:id),
              entity_attrs
            )
          end
        end

        private

        def path(slug:, locale:)
          [
           '/api',
           locale,
           type,
           slug
          ].compact
           .join('/')
           .downcase + '.json'
        end

        def type
          self.name
        end

        def http
          Mas::Cms::Client.connection
        end
      end
    end
  end
end
