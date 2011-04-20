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
      yield res_class
    end

    get '/:resource/:id' do |resource, id|
      access resource, :get do |res_class|
        begin
          res_class.get(id)
        rescue
          status 404
        end          
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
    
    post '/:resource/:id' do |resource, id|
      access resource, :post do |res_class|
      end
    end

    options %r{\*} do; end
  end
end
