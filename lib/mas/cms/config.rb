module Mas
  module Cms
    class Config
      attr_accessor :timeout, :host, :open_timeout, :api_token, :retries, :cache, :cache_gets
    end
  end
end
