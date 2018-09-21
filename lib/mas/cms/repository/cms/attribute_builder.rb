require 'mas/cms/repository/cms/block_composer'

module Mas::Cms::Repository
  module CMS
    class AttributeBuilder
      attr_reader :response_body, :options

      def initialize(response_body, options = {})
        @response_body = response_body
        @options = options
      end

      def self.build(response_body, options)
        new(response_body, options).attributes
      end

      def attributes
        attributes = response_body

        assign_title_from_label(attributes)
        assign_body_from_content_block(attributes)
        assign_blocks_excluding_content(attributes)

        translate_attributes_from_raw_blocks(attributes)
        group_nested_attributes(attributes)

        assign_description(attributes)
        assign_meta_title(attributes)
        assign_categories(attributes)
        assign_alternates(attributes)

        attributes
      end

      private

      def assign_title_from_label(attributes)
        attributes['title'] = attributes['label']
      end

      def assign_body_from_content_block(attributes)
        attributes['body'] = BlockComposer.new(attributes['blocks']).to_html
      end

      def assign_blocks_excluding_content(attributes)
        blocks_without_content = attributes['blocks'].reject do |block|
          block['identifier'] == 'content'
        end

        attributes['non_content_blocks'] = Array(blocks_without_content).map do |block|
          ::Mas::Cms::Block.new(
            identifier: block['identifier'],
            content: block['content']
          )
        end
      end

      def assign_description(attributes)
        attributes['description'] = attributes['meta_description']
      end

      def assign_meta_title(attributes)
        attributes['meta_title'] = attributes['meta_title']
      end

      def assign_categories(attributes)
        attributes['categories'] = Array(attributes['category_names']).map do |category_name|
          Mas::Cms::Category.find(category_name, options)
        end
      end

      def assign_alternates(attributes)
        attributes['alternates'] = Array(attributes['translations']).map do |translation|
          { url: translation['link'], title: translation['label'], hreflang: translation['language'] }
        end
      end

      def translate_attributes_from_raw_blocks(attributes)
        Array(attributes['blocks']).select { |h| h['identifier'].start_with?('raw_') }.each do |h|
          key = h['identifier'].gsub(/^raw_/, '')
          attributes[key] = h['content']
        end
      end

      def group_nested_attributes(attributes)
        nested_attributes(attributes).each do |k, v|
          _, object, number, field = extract_generic_attributes(k)
          index = number.to_i - 1
          key = object.pluralize

          attributes[key] ||= []
          attributes[key][index] ||= {}
          attributes[key][index][field] = v
        end
      end

      def nested_attributes(attributes)
        attributes.select { |k, _| k.match(/_(\d+)_/) }
      end

      def extract_generic_attributes(key)
        key.match(/(\w+)_(\d+)_(\w+)/).to_a
      end
    end
  end
end
