module Mas::Cms
  class Article < Page
    Alternate = Struct.new(:title, :url, :hreflang)

    attr_accessor :type,
                  :slug,
                  :identifier,
                  :title,
                  :description,
                  :meta_title,
                  :body,
                  :categories,
                  :related_content,
                  :supports_amp,
                  :non_content_blocks,
                  :full_path,
                  :tags
    attr_reader :alternates

    alias_method :meta_description, :description

    ROOT_NAME = 'documents'.freeze

    validates_presence_of :title, :body

    def self.root_name
      ROOT_NAME
    end

    def alternates=(alternates)
      @alternates = alternates.map do |alternate|
        Alternate.new(*alternate.values_at(:title, :url, :hreflang))
      end
    end

    def only_child?
      @categories.compact.one?
    end

    def latest_blog_post_links
      build_article_links 'latest_blog_post_links'
    end

    def popular_links
      build_article_links 'popular_links'
    end

    def related_links
      build_article_links 'related_links'
    end

    def previous_link
      navigation_link 'previous_link'
    end

    def next_link
      navigation_link 'next_link'
    end

    def redirect?
      false
    end

    EXCLUDED_FROM_FEEDBACK = [
      'baby-costs-calculator',
      'cyfrifiannell-costau-babi',
      'debt-management-companies'
    ].freeze

    def accepts_feedback?
      !EXCLUDED_FROM_FEEDBACK.include?(slug)
    end

    private

    def build_article_links(key)
      return [] if related_content.blank? || related_content[key].blank?
      related_content[key].map do |link_data|
        build_article_link link_data
      end
    end

    def build_article_link(data)
      ArticleLink.new(data['title'], data['path'])
    end

    def navigation_link(key)
      return nil if related_content.nil? || related_content[key].blank?

      build_article_link related_content[key]
    end
  end
end
