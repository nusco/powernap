require_relative '../resource'

# Adapter for in-memory resources
module PowerNap
  module Memory
    def self.included(base)
      base.send :include, PowerNap::Resource
      base.extend ClassMethods
    end
    
    attr_reader :fields
    
    def id
      # FIXME: remove
      @fields['_id']
    end
    
    def initialize(json)
      @fields = {'_id' => self.class.next_id}.merge(JSON.parse(json))
    end

    def get
      @fields.to_json
    end

    def put(resource)
      @fields = JSON.parse(resource).to_hash
    end

    def delete
      self.class.resources.delete fields['_id']
    end
    
    def method_missing(name, *args)
      field = name.to_s.gsub(/=$/, '')
      super unless @fields.has_key? field
      if name.to_s.ends_with? '='
        @fields[field] = args[0]
      else
        @fields[field]
      end
    end
    
    module ClassMethods
      def get
        resources.values.map {|r| r.fields }
      end

      def post(json)
        resource = new(json)
        resources[resource.id] = resource
        resource.id
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

      def next_id
        @next_id ||= 0
        @next_id += 1
        "#{@next_id}"
      end
    end
  end
end
