require 'mongoid'

# Shared methods for all resouces
module PowerNap
  module Resource
    module ClassMethods
      def allow_header
        allowed = [:get, :post, :put, :delete] & public_instance_methods
        allowed.map(&:upcase).join(', ')
      end

      attr_writer :url
      
      def url
        @url || name.downcase.pluralize
      end
    end
  end
end
