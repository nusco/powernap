require 'sinatra/base'
require 'erb'

module PowerNap
  APPLICATION = Sinatra.new do

    set :views, File.dirname(__FILE__) + '/views'

    require 'rack/content_length'
    use Rack::ContentLength
    
    options %r{\*} do; end
    
    def self.define_urls_for(resource_class)
      def access(res_class, http_method)
        if [:get, :post, :put, :delete].include?(http_method)
          unless res_class.allowed_methods.include?(http_method)
            status 405
            headers 'Allow' => res_class.allowed_methods_as_string
            return
          end
        end
        begin
          yield
        rescue
          status 404
        end          
      end

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

      get "/#{resource_class.url}/:id" do |id|
        access resource_class, :get do
          resource_class[id].get.to_json
        end
      end
      
      put "/#{resource_class.url}/:id" do |id|
         access resource_class, :put do
          resource_class[id].put(request.body.read)
          # FIXME: this sucks. find a decent way to access Rack request headers (or fix Rack)
          headers 'Allow' => resource_class.allowed_methods_as_string if request.env['HTTP_ALLOW']
        end
      end
      
      delete "/#{resource_class.url}/:id" do |id|
        access resource_class, :delete do
          resource_class[id].delete
        end
      end

      options "/#{resource_class.url}/:id" do |id|
        access resource_class, :options do
          resource_class[id] # check that the resource does exist
          headers 'Allow' => resource_class.allowed_methods_as_string
        end
      end
      
      
      post "/#{resource_class.url}" do 
        access resource_class, :post do
          status 201
          resource_class.post(request.body.read)
        end
      end
    end
  end
end
