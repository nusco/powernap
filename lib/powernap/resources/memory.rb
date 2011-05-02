module PowerNap
  module Memory
    def self.included(base)
      base.extend PowerNap::Resource::ClassMethods
      base.extend ClassMethods
    end
    
    attr_reader :id, :fields
    
    def initialize(id, fields)
      @id, @fields = id, fields
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
      def next_id
        @next_id ||= 0
        @next_id += 1
        "#{@next_id}"
      end
      
      def post(new_resource)
        id = next_id
        resources[id] = new(id, JSON.parse(new_resource))
        id
      end
      
      def resources
        @resources ||= {}
      end
      
      def all
        resources.values
      end
      
      def list
        resources.keys.map {|id| resources[id].fields.merge({'id' => id}) }
      end
      
      def delete_all
        resources.clear
      end
      
      def [](id)
        raise HttpException.new([404, {}, []]) unless resources.has_key? id
        resources[id]
      end
    end
  end
end
