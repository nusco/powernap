require 'sinatra/base'
require 'erb'

module PowerNap
  APPLICATION = Sinatra.new do

    set :views, File.dirname(__FILE__) + '/views'

    def access(resource, http_method)
      res_class = PowerNap.resource_classes.find {|r| r.name.downcase.pluralize == resource }
      unless res_class
        status 404; return
      end
      if [:get, :post, :put, :delete].include?(http_method)
        unless res_class.http_methods.include?(http_method)
          status 405
          headers 'Allow' => res_class.http_methods.map {|m| m.upcase }.join(', ')
          return
        end
      end
      begin
        yield res_class
      rescue Mongoid::Errors::DocumentNotFound
        status 404
      end          
    end

    get '/:resource/:id.:representation' do |resource, id, representation|
      access resource, :get do |res_class|
        @resource = res_class.get(id)
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
        res_class.get(id).to_json
      end
    end
    
    post '/:resource' do |new_resource|
      access new_resource, :post do |res_class|
        res_class.post(request.body.read)
      end
    end
    
    put '/:resource/:id' do |resource, id|
      access resource, :put do |res_class|
        res_class.put(id, request.body.read)
      end
    end
    
    delete '/:resource/:id' do |resource, id|
      access resource, :delete do |res_class|
        res_class.delete(id)
      end
    end

    options '/:resource/:id' do |resource, id|
      access resource, :options do |res_class|
        headers 'Allow' => res_class.get(id).allowed_http_methods
      end
    end
    
    options %r{\*} do; end
  end
end
