module PowerNap
  class << self
    def resources
      @resources ||= []
    end

    def register(resource)
      resources << resource
    end
  end

  module Resource
    def self.included(base)
      PowerNap.register base
      base.extend ClassMethods
      base.send :include, PowerNap::PersistentResource
    end

    module ClassMethods
      def http_methods
        @http_methods ||= [:get, :post, :put, :delete]
      end

      def only_responds_to(*http_methods)
        @http_methods = http_methods
      end
    end
  end
end
