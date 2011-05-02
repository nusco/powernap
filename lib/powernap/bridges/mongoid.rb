require 'mongoid'

begin
  Mongo::Connection.new('localhost', 27017).close
rescue Mongo::ConnectionFailure
  puts "                                                                  "
  puts "===================== Hey, where is MongoDB? ====================="
  puts "PowerNap needs a Mongo server running on port 27017.              "
  puts "Start a server with the 'mongod' command.                         "
  puts "                                                                  "
  puts "If you don't have MongoDB yet, you can install it via Homebrew    "
  puts "(type 'brew install mongo'). If you don't have Homebrew, read the "
  puts "quickstart at http://www.mongodb.org/display/DOCS/Quickstart.     "
  puts "=================================================================="
  exit
end

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
      
      def default_url
        name.downcase.pluralize
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
