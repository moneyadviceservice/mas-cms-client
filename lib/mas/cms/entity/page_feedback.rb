module Mas::Cms
  class PageFeedback < Entity
    include Mas::Cms::Resource
    attr_accessor :page_id, :liked, :likes_count, :dislikes_count
  end
end
