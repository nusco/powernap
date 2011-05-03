require './lib/powernap'
require './spec/memory/service'
run Rack::ShowExceptions.new(PowerNap::APPLICATION)
