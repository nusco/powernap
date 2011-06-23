require 'sinatra/base'
require 'erb'

require 'active_support/inflector'

class HttpException < Exception; end

require 'forwardable'

# The HTTP entry point to resources
module PowerNap
  module ConfigurationHelpers
    def resource(res, args = {})
      url = args[:at_url] || ActiveSupport::Inflector.pluralize(res.name.downcase)
      
      get "/#{url}/:id.:extension" do |id, extension|
        access res do
          res[id].get
        end
      end

      post "/#{url}/:id" do |id|
        access res do
          res[id].post(request.body.read)
        end
      end

      put "/#{url}/:id" do |id|
         access res do
          res[id].put(request.body.read)
          headers 'Allow' => res.allow_header if request.env['HTTP_ALLOW']
        end
      end

      delete "/#{url}/:id" do |id|
        access res do
          res[id].delete
        end
      end

      options "/#{url}/:id" do |id|
        access res do
          res[id] # check that the resource does exist
          headers 'Allow' => res.allow_header
        end
      end

      get "/#{url}.:extension" do |extension|
        access res do
           res.get.to_json
        end
      end

      post "/#{url}" do
        access res do
          status 201
          res.post(request.body.read)
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
    
    require 'rack/content_length'
    use Rack::ContentLength

    require_relative 'rack/default_extension'
    use Rack::DefaultExtension

    require_relative 'rack/representations'
    use Rack::Representations

    options %r{\*} do; end

    private
    
    def access(res)
      yield
    rescue NoMethodError
      [405, {'Allow' => res.allow_header}, []]
    end
  end
  
  def self.build_application(&configuration)
    Class.new(PowerNap::Application, &configuration).new
  end
end
