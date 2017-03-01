module Mas::Cms
  class PageFeedback < Entity
    attr_accessor :page_id, :liked, :likes_count, :dislikes_count
  end
end
