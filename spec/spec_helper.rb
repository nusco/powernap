require 'bundler/setup'

require 'rack/test'
ENV['RACK_ENV'] = 'test'

require 'memory_test_service'
require 'mongoid_test_service'
