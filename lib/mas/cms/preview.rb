module Mas::Cms
  module Preview
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def path(slug:, locale:)
        [
          api_prefix,
          'preview',
          locale,
          slug
        ].compact
          .join('/')
          .downcase + '.json'
      end
    end
  end
end
