module Mas::Cms
  class ArticlePreview < Article
    def self.path(slug:, locale:)
      [
        api_prefix,
        'preview',
        locale,
        slug
      ].compact
        .join('/')
        .downcase + '.json'
    end
  end
end
