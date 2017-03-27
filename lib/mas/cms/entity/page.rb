require 'mas/cms/repository/cms/attribute_builder'

module Mas
  module Cms
    class Page < Entity
      include Mas::Cms::Resource

      def self.process_response(response, options={})
        Mas::Cms::Repository::CMS::AttributeBuilder.build(response, options)
      end
    end
  end
end
