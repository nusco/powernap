require 'sinatra/base'

module PowerNap
  class << self
    def resources
      @resources ||= []
    end

    def register(resource)
      resources << resource
    end

  end

  APPLICATION = Sinatra.new do
    get '/' do
      'Hello world!'
    end
  end
end

require_relative 'powernap/resource'
