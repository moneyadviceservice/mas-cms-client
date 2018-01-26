module Mas::Cms
  class VideoPreview < Video
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
