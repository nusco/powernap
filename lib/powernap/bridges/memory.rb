module PowerNap
  module Memory
    def self.included(base)
      base.extend ClassMethods
    end
    
    attr_reader :id, :fields
    
    def initialize(id, fields)
      # FIXME: fields managed this way suck (esp. when converting to JSON)
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
      
      def default_url
        name.downcase.pluralize
      end      
      
      def all
        resources.values
      end
      
      def delete_all
        resources = {}
      end
      
      def [](id)
        result = resources[id]
        # FIXME: exceptions not managed
        raise "404" unless result
        result
      end
    end
  end
end
