require 'mongoid'

module PowerNap
  class << self
    def resource_classes
      @resource_classes ||= []
    end
  end

  module Resource
    def self.included(base)
      PowerNap.resource_classes << base
      base.send :include, ::Mongoid::Document
      base.extend ClassMethods
    end

    module ClassMethods
      def http_methods
        @http_methods ||= [:get, :post, :put, :delete]
      end

      def only_responds_to(*http_methods)
        @http_methods = http_methods
      end

      def get(id)
        find(id)
      end

      def put(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end

      def delete(id)
        find(id).delete
      end

      def post()
      end
    end
  end
end
