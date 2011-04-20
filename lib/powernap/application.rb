require 'sinatra/base'

module PowerNap
  APPLICATION = Sinatra.new do
    put '/books' do
      Book.create(JSON.parse(request.body.read)).id.to_s
    end

    get '/books/:id' do |id|
      Book.find(id).to_json
    end
    
    options '*' do; end
  end
end
