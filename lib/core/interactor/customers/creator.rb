module Core
  module Interactors
    module Customers
      class Creator
        attr_reader :user

        def initialize(user)
          @user = user
        end

        def call(&block)
          customer_id = Registry::Repository[:customers].create(user.to_customer)
          user.customer_id = customer_id
          user.save!
          user
        rescue
          block.call if block_given?
        end
      end
    end
  end
end
