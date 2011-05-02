require 'mongoid'

module PowerNap
  module Resource
    module ClassMethods      
      def default_url
        name.downcase.pluralize
      end
      
      def authorize(http_method)
        return if http_method == :options
        http_method = :get if http_method == :head
        return if allowed_methods.include?(http_method)
        raise HttpException.new([405, {'Allow' => allow_header}, []]) 
      end
      
      def allow_header
        allowed_methods.map(&:upcase).join(', ')
      end

      def url
        @url || default_url
      end
      
      def at_url(url)
        @url = url
        self
      end
      
      private
      
      def allowed_methods
        [:get, :post, :put, :delete] & public_instance_methods
      end
    end
  end
end
