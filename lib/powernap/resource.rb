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

    def allowed_http_methods
      self.class.http_methods.map {|m| m.upcase }.join(', ')
    end    

    module ClassMethods
      def http_methods
        @http_methods ||= [:get, :put, :delete, :post]
      end

      def only_responds_to(*http_methods)
        @http_methods = http_methods
      end

      def get(id)
        find(id)
      end

      def post(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end

      def put(id, resource)
        find(id).update_attributes!(JSON.parse(resource).to_hash)
      end

      def delete(id)
        find(id).delete
      end
    end
  end
end
