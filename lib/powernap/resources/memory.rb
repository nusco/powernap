require_relative '../resource'

module PowerNap
  module Memory
    def self.included(base)
      base.extend PowerNap::Resource::ClassMethods
      base.extend ClassMethods
    end
    
    attr_reader :id, :fields
    
    def initialize(id, fields)
      @id = id
      @fields = {'id' => id}.merge(fields)
    end
    
    def get
      fields
    end

    def put(resource)
      @fields = JSON.parse(resource).to_hash
    end

    def delete
      self.class.resources.delete id
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
        raise HttpException.new([404, {}, []]) unless resources.has_key? id
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
