require "./lib/powernap"
require "./spec/service"
app = PowerNap.build_application do
        resource Book
        resource Author
      end
run Rack::ShowExceptions.new(app)
