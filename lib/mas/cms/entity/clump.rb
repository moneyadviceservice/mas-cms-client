module Mas::Cms
  class Clump < Entity
    include Mas::Cms::Resource
    attr_accessor :name, :description, :categories, :links
    validates_presence_of :name, :description

    def attributes
      {
        name: title,
        description: description,
        categories: categories,
        links: links
      }
    end

    def self.api_prefix
    end
  end
end
