module Mas::Cms
  class Video < Page
    include Mas::Cms::Resource

    attr_accessor :type, :title, :description, :meta_title,
                  :body, :categories, :alternates

    validates_presence_of :title, :body

    def redirect?
      false
    end
  end
end
