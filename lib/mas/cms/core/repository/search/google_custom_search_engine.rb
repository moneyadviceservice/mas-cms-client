require 'core/repository/search/google_custom_search_engine/response_mapper'

module Mas::Cms::Repository
  module Search
    class GoogleCustomSearchEngine < Mas::Cms::Repository::Base
      EVENT_NAME = 'request.google_api.search'

      attr_accessor :page, :per_page

      def initialize(key, cx_en, cx_cy)
        self.connection = Mas::Cms::Registry::Connection[:google_api]
        self.cx_en      = cx_en
        self.cx_cy      = cx_cy
        self.key        = key
      end

      def perform(query, page, per_page)
        response = ActiveSupport::Notifications
          .instrument(EVENT_NAME, query: query, locale: I18n.locale, page: page, per_page: per_page) do

          start_index = ((page * per_page) - (per_page - 1))
          connection.get('customsearch/v1', key: key, cx: localized_cx, num: per_page, q: query, start: start_index)
        end
        ResponseMapper.new(response).mapped_response

      rescue Mas::Cms::Connection::Http::ConnectionFailed, Mas::Cms::Connection::Http::ClientError
        raise RequestError, 'Unable to fetch Search Results from Google Custom Search'
      end

      private

      attr_accessor :connection, :cx_en, :cx_cy, :key

      def localized_cx
        send("cx_#{I18n.locale}")
      end
    end
  end
end
