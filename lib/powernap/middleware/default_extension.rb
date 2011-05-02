require 'rack/utils'

module Rack
  class DefaultExtension
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      if ['GET', 'HEAD'].include?(env['REQUEST_METHOD'])
        unless env['PATH_INFO'] =~ /\.[a-z0-9]*$/
          env['PATH_INFO'] = "#{env['PATH_INFO']}.json"
        end
      end
      @app.call(env)
    end
  end
end
