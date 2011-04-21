require 'mongoid'

module PowerNap
  module MongoidResource
    def self.included(base)
      base.send :include, ::Mongoid::Document
      base.extend HttpMethods
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
    end
  end
end
