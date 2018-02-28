module Mas
  module Cms
    class Document < Mas::Cms::Page
      attr_accessor :label,
                    :slug,
                    :full_path,
                    :meta_description,
                    :meta_title,
                    :category_names,
                    :layout_identifier,
                    :related_content,
                    :blocks

      ROOT_NAME = 'documents'.freeze

      def self.root_name
        ROOT_NAME
      end
    end
  end
end
