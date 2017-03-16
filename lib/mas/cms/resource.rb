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
            http.get(resource_url(slug: slug, locale: locale))
          )
        end

        private

        def resource_url(slug:, locale:)
          "/api/#{locale}/#{type}/#{slug}.json".downcase
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
