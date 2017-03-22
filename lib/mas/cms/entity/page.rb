require 'mas/cms/repository/cms/attribute_builder'

module Mas
  module Cms
    class Page
      include Mas::Cms::Resource

      def self.process_response(response)
        Mas::Cms::Repository::CMS::AttributeBuilder.build(response)
      end
    end
  end
end
