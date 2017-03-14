module Mas::Cms
  class CorporateReader < ArticleReader
    private

    def entity_class
      CorporateArticle
    end

    def repository
      Registry::Repository[:corporate]
    end
  end
end
