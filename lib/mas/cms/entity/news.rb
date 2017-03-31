module Mas::Cms
  class News < Article
    attr_reader :date

    def date=(date)
      @date = DateTime.parse(date).utc.to_datetime
    end
  end
end
