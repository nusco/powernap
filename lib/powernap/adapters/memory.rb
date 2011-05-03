require_relative '../resource'

# Adapter for in-memory resources
module PowerNap
  module Memory
    def self.included(base)
      base.extend PowerNap::Resource::ClassMethods
      base.extend ClassMethods
    end
    
    attr_reader :fields
    
    def initialize(id, fields)
      @fields = {'id' => id}.merge(fields)
    end

    def get
      fields
    end

    def put(resource)
      @fields = JSON.parse(resource).to_hash
    end

    def delete
      self.class.resources.delete fields['id']
    end
    
    module ClassMethods
      def get
        resources.values.map {|r| r.fields }
      end

      def post(new_resource)
        id = next_id
        resources[id] = new(id, JSON.parse(new_resource))
        id
      end
      
      def [](id)
        raise Sinatra::NotFound unless resources.has_key? id
        resources[id]
      end
      
      def delete_all
        resources.clear
      end
    
      def resources
        @resources ||= {}
      end
      
      private 

      def next_id
        @next_id ||= 0
        @next_id += 1
        "#{@next_id}"
      end
    end
  end
end
