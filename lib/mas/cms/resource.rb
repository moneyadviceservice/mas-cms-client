require 'active_support/inflector'

module Mas
  module Cms
    module Resource
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def resource_type(rtype)
          @resource_type = rtype
        end

        def resource_name
          (@resource_type || self.name.demodulize.underscore.pluralize).to_s
        end

        def find(slug, locale: 'en', cached: Mas::Cms::Client.config.cache_gets)
          attributes = process_response(
            http.get(
              path(slug: slug, locale: locale),
              cached: cached
            ),
            locale: locale,
            cached: cached
          )
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

        def process_response(response, options={})
          response.body
        end

        def path(slug:, locale:)
          [
           '/api',
           locale,
           resource_name,
           slug
          ].compact
           .join('/')
           .downcase + '.json'
        end

        def http
          Mas::Cms::Client.connection
        end
      end
    end
  end
end
