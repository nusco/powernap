require 'json'

module PowerNap
  module Resource
    def self.included(base)
      base.extend CollectionOfResources
    end

    attr_reader :fields

    def initialize(fields)
      fields = JSON.parse(fields) unless fields.class == Hash
      @fields = {'id' => self.class.next_id}.merge(fields)
      @fields.each_key do |f|
        raise "Field \"#{f}\"  clashes with the method of the same name" if methods.include? f.to_sym
      end
    end

    def GET
      fields
    end

    def PUT(resource)
      @fields = JSON.parse(resource).to_hash
    end

    def DELETE
      self.class.resources.delete fields['id']
    end
  
    def method_missing(name, *args)
      field = name.to_s.gsub(/=$/, '')
      super unless fields.has_key? field
      if name.to_s.end_with? '='
        fields[field] = args[0]
      else
        fields[field]
      end
    end
  
    module CollectionOfResources
      def GET
        resources.values.map {|r| r.fields }
      end

      def POST(json)
        resource = new(json)
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
