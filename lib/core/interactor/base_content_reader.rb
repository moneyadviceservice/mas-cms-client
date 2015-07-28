module Core
  class BaseContentReader
    attr_accessor :id

    def initialize(id)
      self.id = id
    end

    def call
      data   = repository.find(id)
      entity = entity_class.new(id, data)

      if entity.valid?
        entity.tap do |a|
          a.categories = build_categories(a.categories)
        end
      elsif block_given?
        yield
      end
    end

    private

    def entity_class
      raise NotImplementedError
    end

    def repository
      raise NotImplementedError
    end

    def build_categories(category_ids)
      category_ids.map do |category_id|
        CategoryReader.new(category_id).call
      end
    end
  end
end
