require 'mongoid'

# Class methods for all resouces
module PowerNap
  module Resource
    module ClassMethods
      def allow_header
        allowed = [:get, :post, :put, :delete] & public_instance_methods
        allowed.map(&:upcase).join(', ')
      end
    end
  end
end
