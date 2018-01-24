module Mas::Cms
  class HomePagePreview < HomePage
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
