module Mas::Cms
  module Interactors
    class UserUpdater
      attr_reader :user
      delegate :customer_id, to: :user

      def initialize(user)
        @user = user
      end

      def call
        if customer_id.present?
          Mas::Cms::Registry::Repository[:user].update_from_crm(user)
        end
      end
    end
  end
end
