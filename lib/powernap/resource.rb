require 'json'

module PowerNap
  module Resource
    def self.included(base)
      base.extend CollectionOfResources
      class << base
        def fields
          @fields ||= [:id]
        end
        
        def exposes(*field_names)
          field_names.each do |field|
            fields << field.to_sym
            define_method field do
              instance_variable_get "@#{field}"
            end unless instance_methods.include?(field)
            define_method "#{field}=" do |value|
              instance_variable_set "@#{field}", value
            end unless instance_methods.include?("#{field}=".to_sym)
          end
        end
      end
    end
    
    def initialize(fields)
      fields.each {|field, value| send "#{field}=", value }
      # TODO: I should call super() to avoid overwriting existing base class initialize() here
      #       write a test for this
    end

    def id
      object_id.to_s
    end
    
    def GET
      self.class.fields.inject({}) do |result, field|
        result[field] = send field
        result
      end
    end

    def PUT(resource)
      fields = JSON.parse(resource).to_hash
      fields.each {|field, value| send "#{field}=", value }
    end

    def DELETE
      self.class.resources.delete id
    end
  
    module CollectionOfResources
      def GET
        resources.values.map {|resource| resource.GET }
      end

      def POST(json)
        resource = new(JSON.parse json)
        resources[resource.id] = resource
        resource.id
      end

      def DELETE
        resources.clear
      end

      def resources
        @resources ||= {}
      end
  
      def [](id)
        resources[id] or raise Sinatra::NotFound
      end

      def allow_header
        ([:GET, :POST, :PUT, :DELETE] & public_instance_methods).join(', ')
      end
    end
  end
end
