module Mas::Cms
  class HomePagePreviewer < HomePageReader
    private

    def repository
      Registry::Repository[:preview]
    end
  end
end
