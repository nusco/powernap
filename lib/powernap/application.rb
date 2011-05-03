require 'sinatra/base'
require 'erb'

# The HTTP entry point to resources
module PowerNap
  class HttpException < Exception; end

  def self.resource(res_class)
    APPLICATION.define_routes_for res_class
    APPLICATION.define_routes_for_collection_of res_class
  end
  
  APPLICATION = Sinatra.new do
    set :views, File.dirname(__FILE__) + '/views'

    require_relative 'default_extension'
    use Rack::DefaultExtension

    require 'rack/content_length'
    use Rack::ContentLength    
    
    def access(res_class)
      yield
    rescue NoMethodError => e
      [405, {'Allow' => res_class.allow_header}, []]
    rescue HttpException => e
      e.message
    end

    options %r{\*} do; end
  
    def self.define_routes_for(res_class)
      get "/#{res_class.url}/:id.:extension" do |id, extension|
        access res_class do
          @resource = res_class[id].get
          case extension
          when 'html'
            erb :resource
          when 'json'
            @resource.to_json
          else
            status 415
          end
        end
      end
    
      put "/#{res_class.url}/:id" do |id|
         access res_class do
          res_class[id].put(request.body.read)
          headers 'Allow' => res_class.allow_header if request.env['HTTP_ALLOW']
        end
      end
    
      delete "/#{res_class.url}/:id" do |id|
        access res_class do
          res_class[id].delete
        end
      end

      post "/#{res_class.url}/:id" do |id|
        access res_class do
          res_class[id].post(request.body.read)
        end
      end

      options "/#{res_class.url}/:id" do |id|
        access res_class do
          res_class[id] # check that the resource does exist
          headers 'Allow' => res_class.allow_header
        end
      end
    end
  
    def self.define_routes_for_collection_of(res_class)
      get "/#{res_class.url}.:extension" do |extension|
        access res_class do
          case extension
          when 'html'
            @resources = res_class.get
            erb :collection
          when 'json'
            res_class.get.to_json
          else
            status 415
          end
        end
      end

      post "/#{res_class.url}" do
        access res_class do
          status 201
          res_class.post(request.body.read)
        end
      end
      
      options "/#{res_class.url}" do
        access res_class do
          headers 'Allow' => "GET, POST"
        end
      end
    end    
  end
end
