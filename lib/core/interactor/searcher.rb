module Core
  class Searcher

    DEFAULT_PAGE = 1
    DEFAULT_PER_PAGE = 10

    PAGE_LIMIT = 5
    PER_PAGE_LIMIT = 10

    attr_accessor :query
    attr_writer :page, :per_page

    private :query=, :page=, :per_page=

    def initialize(query, options = {})
      self.query = query
      self.page = options[:page].to_i if options[:page]
      self.per_page = options[:per_page].to_i if options[:per_page]
    end

    def call
      options = { total_results: total_results, page: request_page, per_page: request_per_page }
      SearchResultCollection.new(options).tap do |results_collection|
        items.each do |result_data|
          new_result = SearchResult.new(result_data.delete(:id), result_data)
          if new_result.valid?
            results_collection << new_result
          else
            Rails.logger.info("Invalid search result: #{new_result.inspect}")
          end
        end
      end
    end

    private

    def data
      @data ||= Registry::Repository[:search].perform(query, request_page, request_per_page)
    end

    def page
      @page ||= DEFAULT_PAGE
    end

    def per_page
      @per_page ||= DEFAULT_PER_PAGE
    end

    def request_page
      if page > 0
        [page, PAGE_LIMIT].min
      else
        1
      end
    end

    def request_per_page
      [per_page, PER_PAGE_LIMIT].min
    end

    def total_results
      data[:total_results]
    end

    def items
      data[:items]
    end
  end
end
