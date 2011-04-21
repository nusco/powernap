require 'sinatra/base'

module PowerNap
  APPLICATION = Sinatra.new do
    def access(resource, http_method)
      res_class = PowerNap.resources.find {|r| r.name.downcase.pluralize == resource }
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

    get '/:resource/:id' do |resource, id|
      access resource, :get do |res_class|
        res_class.get(id)
      end
    end
    
    put '/:resource' do |resource|
      access resource, :put do |res_class|
        res_class.put(request.body.read)
      end
    end
    
    delete '/:resource/:id' do |resource, id|
      access resource, :delete do |res_class|
        res_class.delete(id)
      end
    end
    
    post '/:resource' do |resource|
      access resource, :post do |res_class|
        res_class.post
      end
    end

    options %r{\*} do; end
  end
end
