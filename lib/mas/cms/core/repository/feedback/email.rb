module Mas::Cms::Repository
  module Feedback
    class Email < Mas::Cms::Repository::Base
      attr_accessor :connection
      private :connection

      def initialize
        self.connection = Mas::Cms::Registry::Connection[:internal_email]
      end

      def create(entity)
        email_details = {
          recipient: entity.recipient,
          subject:   entity.subject,
          body:      entity.body
        }
        connection.deliver(email_details)
      end
    end
  end
end
