require './lib/powernap'
require './spec/memory/service'
app = PowerNap.build_application do
        resource Book
        resource Author
      end
run Rack::ShowExceptions.new(app)
