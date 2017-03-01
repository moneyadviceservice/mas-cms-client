module Mas::Cms
  class PageFeedbackAction
    def action(action_method, params)
      data = repository.send(action_method, params)
      return false if data.blank?

      entity.new(data['id'], data)
    end

    def repository
      Mas::Cms::Registry::Repository[:page_feedback]
    end

    def entity
      Mas::Cms::PageFeedback
    end
  end
end
