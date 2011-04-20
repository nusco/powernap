require 'sinatra/base'

module PowerNap
  APPLICATION = Sinatra.new do
    options '/' do
      'Hello world!'
    end
  end
end
