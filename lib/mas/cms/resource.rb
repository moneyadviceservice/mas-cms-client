module Mas
  module Cms
    module Resource
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def find(slug:, locale: 'en')
          attributes = process_response(http.get(path(slug: slug, locale: locale)))

          new(slug, attributes)
        end

        def all(locale: 'en')
          response_body = http.get(path(slug: nil, locale: locale)).body
          response_body.map do |entity_attrs|
            new(
              entity_attrs.delete(:id),
              entity_attrs
            )
          end
        end

        private

        def process_response(response)
          Mas::Cms::Repository::CMS::AttributeBuilder.build(response)
        end

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
