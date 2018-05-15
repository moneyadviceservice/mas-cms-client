module Mas
  module Cms
    class ResponseCollection < Array
      attr_reader :response, :response_body, :collection

      def initialize(collection, response)
        @response = response
        @response_body = response.body
        @collection = collection

        super(@collection)
      end

      def meta
        @response_body.symbolize_keys[:meta]
      end

      def inspect
        "#<ResponseCollection:#{object_id} #{collection}>"
      end
    end
  end
end
