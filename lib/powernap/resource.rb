require 'json'

module PowerNap
  module Resource
    def self.included(base)
      base.extend CollectionOfResources
    end

    attr_reader :fields
    attr_reader :id
    
    def initialize(fields)
      @id = self.class.next_id
      @fields = fields
      fields.each do |field, value|
        send "#{field}=", value
      end
      # TODO: I should call super() to avoid overwriting existing base class initialize() here
      #       write a test for this
    end

    def GET
      result = { 'id' => id }
      @fields.keys.each do |field|
        result[field] = send field
      end
      result
    end

    def PUT(resource)
      fields = JSON.parse(resource).to_hash
      @fields = fields
      fields.each do |field, value|
        send "#{field}=", value
      end
    end

    def DELETE
      self.class.resources.delete id
    end
  
    module CollectionOfResources
      def GET
        resources.values.map {|resource| resource.fields }
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

      def next_id
        @next_id ||= 0
        (@next_id += 1).to_s
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
