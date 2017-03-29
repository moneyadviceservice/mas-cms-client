module Mas::Cms
  class Clump < Entity
    include Mas::Cms::Resource
    attr_accessor :name, :description, :categories, :links
    validates_presence_of :name, :description

    def attributes
      {
        name: title,
        description: description,
        categories: categories,
        links: links
      }
    end

    class << self
      def api_prefix
      end

      def resource_attributes(response_body, options={})
        body = response_body.dup
        body
      end

      private
    end
  end
end
