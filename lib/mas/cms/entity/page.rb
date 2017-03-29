require 'mas/cms/repository/cms/attribute_builder'

module Mas
  module Cms
    class Page < Entity
      include Mas::Cms::Resource

      def self.resource_attributes(response_body, options={})
        Mas::Cms::Repository::CMS::AttributeBuilder.build(response_body, options)
      end
    end
  end
end
