module Mas::Cms
  class Block
    include ActiveModel::Model

    attr_accessor :identifier, :content

    def ==(other)
      identifier == other.identifier && content == other.content
    end
  end
end
