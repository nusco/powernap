require 'mongoid'

module PowerNap
  module Resource
    def self.included(base)
      PowerNap.register base
      base.extend ClassMethods
      base.send :include, Mongoid::Document
    end

    module ClassMethods
      def http_methods
        @http_methods ||= []
      end

      def responds_to(*methods)
        @http_methods = methods
      end
    end
  end
end
