module Mas::Cms
  class PageFeedbackCreator < PageFeedbackAction
    def call(params)
      action(:create, params)
    end
  end
end
