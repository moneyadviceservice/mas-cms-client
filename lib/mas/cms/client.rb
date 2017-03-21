require 'mas/cms/config'

module Mas
  module Cms
    module Client
      def self.config
        @@config ||= ::Mas::Cms::Config.new

        yield @@config if block_given?

        @@config
      end

      def self.connection
        @@conn ||= Mas::Cms::Connection.new
      end
    end
  end
end
