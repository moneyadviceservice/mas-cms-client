module Mas::Cms
  class PageFeedback < Entity
    include Mas::Cms::Resource
    attr_accessor :page_id, :liked, :likes_count, :dislikes_count

    def self.path(slug:, locale:)
      [
        api_prefix,
        locale,
        slug,
        resource_name
      ].compact
        .join('/')
        .downcase
    end
  end
end
