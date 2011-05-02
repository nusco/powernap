require 'sinatra/base'
require 'erb'

module PowerNap
  class HttpException < Exception; end

  def self.resource(resource_class)
    APPLICATION.define_routes_for resource_class
    APPLICATION.define_routes_for_collection_of resource_class
  end
  
  APPLICATION = Sinatra.new do
    set :views, File.dirname(__FILE__) + '/views'

    use Rack::DefaultExtension

    require 'rack/content_length'
    use Rack::ContentLength    
    
    def access(resource_class, http_method)
      resource_class.authorize http_method
      yield
    rescue HttpException => e
      e.message
    end
  
    options %r{\*} do; end
  
    def self.define_routes_for(resource_class)
      get "/#{resource_class.url}/:id.:representation" do |id, representation|
        access resource_class, :get do
          @resource = resource_class[id].get
          case representation
          when 'html'
            erb :resource
          when 'json'
            @resource.to_json
          else
            # FIXME: use Illegal Representation here?
            status 404
          end
        end
      end
    
      put "/#{resource_class.url}/:id" do |id|
         access resource_class, :put do
          resource_class[id].put(request.body.read)
          headers 'Allow' => resource_class.allow_header if request.env['HTTP_ALLOW']
        end
      end
    
      delete "/#{resource_class.url}/:id" do |id|
        access resource_class, :delete do
          resource_class[id].delete
        end
      end

      post "/#{resource_class.url}/:id" do |id|
        access resource_class, :post do
          resource_class[id].post(request.body.read)
        end
      end

      options "/#{resource_class.url}/:id" do |id|
        access resource_class, :options do
          resource_class[id] # check that the resource does exist
          headers 'Allow' => resource_class.allow_header
        end
      end
    end
  
    def self.define_routes_for_collection_of(resource_class)
      get "/#{resource_class.url}.:representation" do |representation|
        access resource_class, :get do
          case representation
          when 'html'
            @resources = resource_class.get
            erb :collection
          when 'json'
            resource_class.get.to_json
          else
            # FIXME: use Illegal Representation here?
            status 404
          end
        end
      end

      post "/#{resource_class.url}" do
        access resource_class, :post do
          status 201
          resource_class.post(request.body.read)
        end
      end
      
      options "/#{resource_class.url}" do
        access resource_class, :options do
          headers 'Allow' => "GET, POST"
        end
      end
    end    
  end
end
