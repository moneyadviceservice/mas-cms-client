module Mas
  module Cms
    module Errors
      class Base < StandardError
        attr_reader :original
        
        def initialize(original = $ERROR_INFO)
          super
          @original = original
        end
      end
    end
  end
end
