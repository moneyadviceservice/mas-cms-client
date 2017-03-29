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

        def all(locale: 'en', cached: Mas::Cms::Client.config.cache_gets)
          response_body = http.get(path(slug: nil, locale: locale), cached: cached).body
          response_body.map do |entity_attrs|
            new(
              entity_attrs.delete(:id),
              resource_attributes(entity_attrs, locale: locale, cached: cached)
            )
          end
        end

        def api_prefix
          '/api'.freeze
        end

        private

        def resource_attributes(response_body, options={})
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
