require_relative '../resource'
require 'mongoid'

# TODO: extenalize config
Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("powernap")
end

# Adapter for Mongoid resources
module PowerNap
  module Mongoid
    def self.included(base)
      base.send :include, PowerNap::Resource
      base.extend ClassMethods
    end
    
    def get
      self.to_json
    end

    def put(resource)
      update_attributes!(JSON.parse(resource).to_hash)
    end

    def delete
      super
    end
    
    module ClassMethods
      def get
        all
      end

      def post(new_resource)
        create(JSON.parse(new_resource)).id.to_s
      end
      
      def [](id)
        find(id)
      rescue
        raise Sinatra::NotFound
      end
    end
  end
end
