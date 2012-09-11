require "bundler/setup"
require "./lib/powernap"

require "rack/test"
ENV["RACK_ENV"] = "test"
