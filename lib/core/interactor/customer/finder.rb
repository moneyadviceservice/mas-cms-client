module Core
  module Interactors
    module Customer
      class Finder
        attr_reader :id

        def initialize(id)
          @id = id
        end

        def call(&block)
          data = Registry::Repository[:customer].find(id)

          if data
            customer = ::Core::Customer.new(id, data)
          else
            block.call if block_given?
          end
        end
      end
    end
  end
end
