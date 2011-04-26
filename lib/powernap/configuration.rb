require 'mongoid'

begin
  Mongo::Connection.new('localhost', 27017).close
rescue Mongo::ConnectionFailure
  puts "                                                                  "
  puts "===================== Hey, where is MongoDB? ====================="
  puts "PowerNap needs a Mongo server running on port 27017.              "
  puts "Start a server with the 'mongod' command.                         "
  puts "                                                                  "
  puts "If you don't have MongoDB yet, you can install it via Homebrew    "
  puts "(type 'brew install mongo'). If you don't have Homebrew, read the "
  puts "quickstart at http://www.mongodb.org/display/DOCS/Quickstart.     "
  puts "=================================================================="
  exit
end

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("powernap")
end
