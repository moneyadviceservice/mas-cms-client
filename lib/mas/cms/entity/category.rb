module Mas::Cms
  class Category < Entity
    include Mas::Cms::Resource
    attr_accessor :type, :parent_id, :title, :description, :contents, :third_level_navigation, :images, :links, :category_promos, :legacy_contents, :legacy
    validates_presence_of :title

    class << self
      def resource_attributes(response_body, options={})
        body = response_body.dup
        body[:contents] = build_contents(body[:contents], options)
        body[:legacy_contents] = build_contents(body[:legacy_contents], options)
        body
      end

      private
      def build_contents(contents, options)
        return [] unless contents.present?

        contents.map do |item|
          klass = content_item_type_to_entity_class.fetch(item['type'], Other)
          if klass == Category
            find(item['id'], options)
          else
            klass.new(item['id'], item)
          end
        end
      end

      def content_item_type_to_entity_class
        {
          nil           => Category,
          'guide'       => Article,
          'action_plan' => ActionPlan,
          'article'     => Article,
          'corporate'   => Corporate,
          'footer'      => Footer,
          'home_page'   => HomePage,
          'news'        => NewsArticle,
          'tool'        => Other,
          'video'       => Video
        }
      end
    end

    def categories
      contents.delete_if { |c| c.type != 'category' }
    end

    def third_level_navigation?
      third_level_navigation
    end

    def legacy?
      legacy
    end

    def child?
      contents.blank? || contents.any? { |c| c.class != Category }
    end

    def parent?
      contents.any? { |c| c.try(:child?) }
    end

    def home?
      false
    end

    def news?
      false
    end

    def corporate?
      false
    end

    def redirect?
      false
    end

    def attributes
      {
        type: type,
        parent_id: parent_id,
        title: title,
        description: description,
        contents: contents,
        legacy_contents: legacy_contents,
        images: images,
        links: links
      }
    end
  end
end
