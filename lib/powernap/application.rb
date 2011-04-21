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
      unless res_class.http_methods.include?(http_method)
        status 405; return
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
      access new_resource, :put do |res_class|
        res_class.post(request.body.read)
      end
    end
    
    delete '/:resource/:id' do |resource, id|
      access resource, :delete do |res_class|
        res_class.delete(id)
      end
    end
    
    put '/:resource/:id' do |resource, id|
      access resource, :post do |res_class|
        res_class.put(id, request.body.read)
      end
    end

    options %r{\*} do; end
  end
end
