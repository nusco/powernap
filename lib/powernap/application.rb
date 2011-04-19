require 'sinatra/base'

module PowerNap
  APPLICATION = Sinatra.new do
    get '/' do
      'Hello world!'
    end
  end
end
