require 'sinatra/base'

module PowerNap
  APPLICATION = Sinatra.new do
    def special_case?(resource, http_method)
      resource_class = PowerNap.resources.find {|r| r.name.downcase.pluralize == resource }
      unless resource_class
        status 404
        return nil
      end
      unless resource_class.http_methods.include?(http_method)
        status 405
        return nil
      end
      resource_class
    end
    
    put '/:resource' do |resource|
      resource_class = special_case?(resource, :put)
      return unless resource_class

      resource_class.create(JSON.parse(request.body.read)).id.to_s
    end

    get '/:resource/:id' do |resource, id|
      resource_class = special_case?(resource, :get)
      return unless resource_class

      resource_class.find(id).to_json
    end
    
    delete '/:resource/:id' do |resource, id|
      resource_class = special_case?(resource, :delete)
      return unless resource_class
    end

    options %r{\*} do; end
  end
end
