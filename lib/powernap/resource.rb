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
      def get(id)
        find(id).to_json
      end

      def put(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end
      
      def delete(id)
        find(id).delete
      end
      
      def post()
      end
      
      def http_methods
        @http_methods ||= [:get, :post, :put, :delete]
      end

      def only_responds_to(*http_methods)
        @http_methods = http_methods
      end
    end
  end
end
