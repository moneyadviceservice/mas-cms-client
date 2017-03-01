module Mas::Cms
  class VideoReader < BaseContentReader
    private

    def entity_class
      Video
    end

    def repository
      Registry::Repository[:video]
    end
  end
end
