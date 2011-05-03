require 'mongoid'

module PowerNap
  module Resource
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
