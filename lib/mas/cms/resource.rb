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
          (@resource_type || name.demodulize.underscore.pluralize).to_s
        end

        def api_prefix
          '/api'.freeze
        end

        def find(slug, locale: 'en', cached: Mas::Cms::Client.config.cache_gets)
          attributes = resource_attributes(
            http.get(
              path(slug: slug, locale: locale),
              cached: cached
            ).body,
            locale: locale,
            cached: cached
          )
          new(slug, attributes)
        end

        def all(locale: 'en', cached: Mas::Cms::Client.config.cache_gets, params: nil)
          response = http.get(
            path(slug: nil, locale: locale),
            params: params,
            cached: cached
          )

          records = response_body(response).map do |entity_attrs|
            new(
              entity_attrs.delete(:id),
              resource_attributes(entity_attrs, locale: locale, cached: cached)
            )
          end

          ::Mas::Cms::ResponseCollection.new(records, response)
        end

        def response_body(response)
          if root_name
            response.body[root_name]
          else
            response.body
          end
        end

        def root_name; end

        def create(attributes = {})
          body = http.post(
            path(slug: attributes[:slug], locale: attributes[:locale]),
            attributes
          ).body
          new(body['id'], body)
        end

        def update(attributes = {})
          body = http.patch(
            path(slug: attributes[:slug], locale: attributes[:locale]),
            attributes
          ).body
          new(body['id'], body)
        end

        private

        def resource_attributes(response_body, _)
          response_body
        end

        def path(slug:, locale:)
          [
            api_prefix,
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
