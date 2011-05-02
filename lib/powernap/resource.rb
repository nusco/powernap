require 'mongoid'

module PowerNap
  module Resource
    module ClassMethods
      def allowed_methods
        (self.public_instance_methods & [:get, :put, :delete, :post]).sort
      end

      def allowed_methods_as_string
        allowed_methods.map {|m| m.upcase }.join(', ')
      end
      
      def default_url
        name.downcase.pluralize
      end
    end
  end
end
