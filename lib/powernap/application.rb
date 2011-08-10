require 'sinatra/base'
require 'active_support/inflector'

# The HTTP entry point to resources
module PowerNap
  module ConfigurationHelpers
    def resource(res, args = {})
      url = args[:at_url] || ActiveSupport::Inflector.pluralize(res.name.downcase)
      
      get "/#{url}/:id.:extension" do |id, _|
        access res do
          res[id].GET
        end
      end

      post "/#{url}/:id" do |id|
        access res do
          res[id].POST(request.body.read)
        end
      end

      put "/#{url}/:id" do |id|
         access res do
          res[id].PUT(request.body.read)
          headers 'Allow' => res.allow_header if request.env['HTTP_ALLOW']
        end
      end

      delete "/#{url}/:id" do |id|
        access res do
          res[id].DELETE
        end
      end

      options "/#{url}/:id" do |id|
        access res do
          res[id] # check that the resource does exist
          headers 'Allow' => res.allow_header
        end
      end

      get "/#{url}.:extension" do |_|
        access res do
           res.GET.to_json
        end
      end

      post "/#{url}" do
        access res do
          status 201
          res.POST(request.body.read)
        end
      end

      delete "/#{url}" do
        access res do
          res.DELETE
        end
      end

      options "/#{url}" do
        access res do
          headers 'Allow' => "GET, POST"
        end
      end
    end
  end

  class Application < Sinatra::Base
    register ConfigurationHelpers
    
    require_relative 'rack/default_extension'
    use Rack::DefaultExtension

    require_relative 'rack/representations'
    use Rack::Representations

    use Rack::ContentLength
    
    options %r{\*} do; end

    private
    
    def access(res)
      yield
    rescue NoMethodError
      [405, {'Allow' => res.allow_header}, []]
    end
  end
  
  def self.build_application(&configuration)
    c = Class.new(PowerNap::Application, &configuration).new
  end
end
