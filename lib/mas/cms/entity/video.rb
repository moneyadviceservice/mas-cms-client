module Mas::Cms
  class Video < Entity
    include Mas::Cms::Resource

    attr_accessor :type, :title, :description, :body, :categories, :alternates

    validates_presence_of :title, :body

    def redirect?
      false
    end
  end
end
