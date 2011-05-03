require 'sinatra/base'
require 'erb'

class HttpException < Exception; end

# The HTTP entry point to resources
module PowerNap
  def self.resource(res)
    APPLICATION.define_routes_for res
    APPLICATION.define_routes_for_collection_of res
  end
  
  APPLICATION = Sinatra.new do
    require 'rack/content_length'
    use Rack::ContentLength

    require_relative 'default_extension'
    use Rack::DefaultExtension

    require_relative 'representations'
    use Rack::Representations
    
    def access(res)
      yield
    rescue NoMethodError
      [405, {'Allow' => res.allow_header}, []]      
    end

    options %r{\*} do; end
  
    def self.define_routes_for(res)
      
      get "/#{res.url}/:id.:extension" do |id, extension|
        access res do
          res[id].get
        end
      end
    
      post "/#{res.url}/:id" do |id|
        access res do
          res[id].post(request.body.read)
        end
      end

      put "/#{res.url}/:id" do |id|
         access res do
          res[id].put(request.body.read)
          headers 'Allow' => res.allow_header if request.env['HTTP_ALLOW']
        end
      end
    
      delete "/#{res.url}/:id" do |id|
        access res do
          res[id].delete
        end
      end

      options "/#{res.url}/:id" do |id|
        access res do
          res[id] # check that the resource does exist
          headers 'Allow' => res.allow_header
        end
      end
    end
  
    def self.define_routes_for_collection_of(res)
      get "/#{res.url}.:extension" do |extension|
        access res do
           res.get.to_json
        end
      end

      post "/#{res.url}" do
        access res do
          status 201
          res.post(request.body.read)
        end
      end
      
      options "/#{res.url}" do
        access res do
          headers 'Allow' => "GET, POST"
        end
      end
    end    
  end
end
