module Mas::Cms::Repository
  module Clumps
    class CMS < Mas::Cms::Repository::Base
      def initialize(options = {})
        self.connection = Mas::Cms::Registry::Connection[:cms]
      end

      def all
        clumps_url = '/%{locale}/clumps.json' % { locale: I18n.locale }
        response = connection.get(clumps_url)
        response.body
      rescue => e
        raise RequestError,
              'Unable to fetch Clump JSON from Contento' +
              " url: [#{clumps_url}]" +
              " error: [#{e.inspect}]" +
              " url_prefix: [#{connection.try(:url_prefix).inspect}]"
      end

      private

      attr_accessor :connection
    end
  end
end
