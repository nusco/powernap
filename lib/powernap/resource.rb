require 'mongoid'

module PowerNap
  module Resource
    def self.included(base)
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
      super
    end
    
    module ClassMethods
      def allowed_methods
        @allowed_methods ||= [:get, :post, :put, :delete]
      end

      def allowed_methods_as_string
        allowed_methods.map {|m| m.upcase }.join(', ')
      end
      
      def responds_to(*http_methods)
        @allowed_methods = http_methods
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
