module Mas::Cms
  class Clump < Entity
    include Mas::Cms::Resource
    attr_accessor :name, :description, :meta_title,
                  :categories, :links
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
      def resource_attributes(response_body, _)
        body = response_body.dup
        body['categories'] = Array(body['categories']).map { |category| build_category(category) }
        body['links'] = Array(body['links']).map { |link| ClumpLink.new(link['id'], link) }
        body
      end

      private

      def build_category(attributes)
        Category.new(attributes['id'], attributes).tap do |category|
          category.contents = Array(attributes['contents']).map { |content| build_category(content) }
        end
      end
    end
  end
end
