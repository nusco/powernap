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
    
    def get
      self
    end

    def put(resource)
      update_attributes!(JSON.parse(resource).to_hash)
    end

    def delete
      super.delete
    end

    module ClassMethods
      def http_methods
        @http_methods ||= [:get, :put, :delete, :post]
      end

      def http_methods_as_string
        http_methods.map {|m| m.upcase }.join(', ')
      end
      
      def only_responds_to(*http_methods)
        @http_methods = http_methods
      end

      def post(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end
      
      def [](id)
        find(id)
      rescue Mongoid::Errors::DocumentNotFound
        raise 404
      end
    end
  end
end
