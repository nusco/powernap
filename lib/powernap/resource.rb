require 'mongoid'

# Shared methods for all resouces
module PowerNap
  module Resource
    # TODO: make this a blank slate
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def allow_header
        allowed = [:get, :post, :put, :delete] & public_instance_methods
        allowed.map(&:upcase).join(', ')
      end

      def url
        @url || name.downcase.pluralize
      end
      
      def at_url(url)
        @url = url
        self
      end
    end
  end
end
