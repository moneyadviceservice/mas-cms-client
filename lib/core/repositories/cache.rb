module Core::Repositories
  class Cache < SimpleDelegator
    attr_accessor :cache

    def initialize(obj, cache)
      __setobj__(obj)
      self.cache = cache
    end

    def method_missing(method_name, *args, &block)
      cache_key = [I18n.locale, __getobj__.class.name.underscore, method_name, *args].join('/')

      Marshal.load(Marshal.dump(cache.fetch(cache_key) { super }))
    end
  end
end
