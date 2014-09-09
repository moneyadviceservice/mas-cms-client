module Core
  class SearchResultCollection
    include Enumerable
    extend Forwardable

    attr_accessor :items, :page, :per_page, :total_results, :query

    private :items=, :query=

    def_delegators :items, :<<

    def initialize(attributes = {})
      self.items = attributes.fetch(:items) { [] }
      self.page = attributes[:page]
      self.per_page = attributes[:per_page]
      self.total_results = attributes[:total_results]
      self.query = attributes[:query]
    end

    def each(*args, &block)
      items.each(*args, &block)
    end
  end
end
