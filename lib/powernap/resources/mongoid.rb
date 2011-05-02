require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("powernap")
end

module PowerNap
  module Mongoid
    def self.included(base)
      base.extend ClassMethods
    end
    
    def get
      self
    end

    def put(resource)
      update_attributes!(JSON.parse(resource).to_hash)
    end

    def delete
      super
    end
    
    module ClassMethods
      def post(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end
      
      def delete_all
        super
      end
      
      def all
        super
      end
      
      def list
        all
      end
      
      def [](id)
        find(id)
      rescue Mongoid::Errors::DocumentNotFound
        # FIXME: exceptions not managed
        raise "404"
      end
    end
  end
end
