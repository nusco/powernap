require 'sinatra/base'
require 'erb'

module PowerNap
  APPLICATION = Sinatra.new do

    set :views, File.dirname(__FILE__) + '/views'

    require 'rack/content_length'
    use Rack::ContentLength

    def access(resource, http_method)
      res_class = PowerNap.resource_classes.find {|r| r.name.downcase.pluralize == resource }
      unless res_class
        status 404; return
      end
      if [:get, :post, :put, :delete].include?(http_method)
        unless res_class.http_methods.include?(http_method)
          status 405
          headers 'Allow' => res_class.http_methods_as_string
          return
        end
      end
      begin
        yield res_class
      rescue
        status 404
      end          
    end

    get '/:resource/:id.:representation' do |resource, id, representation|
      access resource, :get do |res_class|
        @resource = res_class[id].get
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

    get '/:resource/:id' do |resource, id|
      access resource, :get do |res_class|
        res_class[id].get.to_json
      end
    end
    
    post '/:resource' do |new_resource|
      access new_resource, :post do |res_class|
        status 201
        res_class.post(request.body.read)
      end
    end
    
    put '/:resource/:id' do |resource, id|
      access resource, :put do |res_class|
        res_class[id].put(request.body.read)
        # FIXME: this sucks. find a decent way to access Rack request headers (or fix Rack)
        headers 'Allow' => res_class.http_methods_as_string if request.env['HTTP_ALLOW']
      end
    end
    
    delete '/:resource/:id' do |resource, id|
      access resource, :delete do |res_class|
        res_class[id].delete
      end
    end

    options '/:resource/:id' do |resource, id|
      access resource, :options do |res_class|
        res_class[id] # check that the resource does exist
        headers 'Allow' => res_class.http_methods_as_string
      end
    end
    
    options %r{\*} do; end
  end
end
