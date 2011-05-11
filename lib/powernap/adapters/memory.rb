require_relative '../resource'

# Adapter for in-memory resources
module PowerNap
  module Resource
    module Memory
      def self.included(base)
        base.extend PowerNap::Resource::ClassMethods
        base.extend ClassMethods
      end

      attr_reader :fields

      def initialize(json)
        fields = JSON.parse(json)
        @fields = {'id' => self.class.next_id}.merge(fields)
        @fields.each_key do |f|
          raise "Reserved field name: \"#{f}\"." if BasicObject.instance_methods.include? f
          raise "Field \"#{f}\" clashes with #{self.class}##{f}()." if super.respond_to? f
        end
      end

      def get
        @fields.to_json
      end

      def put(resource)
        @fields = JSON.parse(resource).to_hash
      end

      def delete
        self.class.resources.delete fields['id']
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
          resources[id] or raise Sinatra::NotFound
        end
  
        def delete_all
          resources.clear
        end

        def resources
          @resources ||= {}
        end

        def next_id
          @next_id ||= 0
          (@next_id += 1).to_s
        end
      end
    end
  end
end
