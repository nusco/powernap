require 'mongoid'

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
      base.extend HttpMethods
      base.send :include, Mongoid::Document
    end

    module HttpMethods
      def http_methods
        @http_methods ||= []
      end

      def responds_to(*http_methods)
        @http_methods = http_methods
      end
    end
  end
end
