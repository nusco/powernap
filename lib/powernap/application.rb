require 'sinatra/base'
require 'erb'

module PowerNap
  def self.resource(resource_class, args = {})
    resource_class.extend PowerNap::Resource::ClassMethods
    url = args[:at] || resource_class.default_url
    APPLICATION.define_routes_for resource_class, url
    APPLICATION.define_routes_for_collection resource_class, url
  end
  
  APPLICATION = Sinatra.new do
    set :views, File.dirname(__FILE__) + '/views'

    require 'rack/content_length'
    use Rack::ContentLength

    def access(resource_class, http_method)
      if [:get, :post, :put, :delete].include?(http_method)
        unless resource_class.allowed_methods.include?(http_method)
          status 405
          headers 'Allow' => resource_class.allowed_methods_as_string
          return
        end
      end
      begin
        yield
      rescue Exception => e
        status e.message.to_i
      end
    end
  
    options %r{\*} do; end
  
    def self.define_routes_for(resource_class, url)
      get "/#{url}/:id.:representation" do |id, representation|
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

      get "/#{url}/:id" do |id|
        access resource_class, :get do
          resource_class[id].get.to_json
        end
      end
    
      put "/#{url}/:id" do |id|
         access resource_class, :put do
          resource_class[id].put(request.body.read)
          # FIXME: this sucks. find a decent way to access Rack request headers (or fix Rack)
          headers 'Allow' => resource_class.allowed_methods_as_string if request.env['HTTP_ALLOW']
        end
      end
    
      delete "/#{url}/:id" do |id|
        access resource_class, :delete do
          resource_class[id].delete
        end
      end

      post "/#{url}/:id" do |id|
        access resource_class, :post do
          resource_class[id].post(request.body.read)
        end
      end

      options "/#{url}/:id" do |id|
        access resource_class, :options do
          resource_class[id] # check that the resource does exist
          headers 'Allow' => resource_class.allowed_methods_as_string
        end
      end
    end
  
    def self.define_routes_for_collection(resource_class, url)
      get "/#{url}" do
        access resource_class, :get do
          resource_class.list.to_json
        end
      end

      get "/#{url}.:representation" do |representation|
        access resource_class, :get do
          case representation
          when 'html'
            @resources = resource_class.list
            erb :collection
          when 'json'
            resource_class.list.to_json
          else
            # FIXME: use Illegal Representation here?
            status 404
          end
        end
      end

      post "/#{url}" do
        access resource_class, :post do
          status 201
          resource_class.post(request.body.read)
        end
      end
      
      options "/#{url}" do
        access resource_class, :options do
          headers 'Allow' => "GET, POST"
        end
      end
    end    
  end
end
