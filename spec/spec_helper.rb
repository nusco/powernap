require "bundler/setup"

require "mongoid"
require "rspec"

require "mongo"
begin
  Mongo::Connection.new('localhost', 27017).close
rescue Mongo::ConnectionFailure
  puts "                                                                  "
  puts "===================== Hey, where is MongoDB? ====================="
  puts "To run these tests, I need a Mongo server running on port 27017.  "
  puts "Start a server with the 'mongod' command.                         "
  puts "                                                                  "
  puts "If you don't have MongoDB yet, you can install it via Homebrew    "
  puts "(type 'brew install mongo'). If you don't have Homebrew, read     "
  puts "the quickstart at http://www.mongodb.org/display/DOCS/Quickstart. "
  puts "=================================================================="
  exit
end

require 'test_app'
