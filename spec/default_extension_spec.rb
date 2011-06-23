require 'powernap/rack/default_extension'

require 'rack/test'
ENV['RACK_ENV'] = 'test'

describe Rack::DefaultExtension do
  include Rack::Test::Methods

  def app
    app = lambda { |env| [200, {}, [env['PATH_INFO']]] }
    Rack::DefaultExtension.new app
  end

  it "should add a .json extension" do
    get '/resources/tests/a_test'
    last_response.body.should == '/resources/tests/a_test.json'
  end

  it "should do nothing if the URL already has an extension" do
    get '/resources/tests/a_test.h2o'
    last_response.body.should == '/resources/tests/a_test.h2o' 
  end

  it "should only accept alphanumeric extensions" do
    get '/resources/tests/a_test.h2_o'
    last_response.body.should == '/resources/tests/a_test.h2_o.json' 
  end

  it "should respond to HEAD requests" do
    head '/x'
    last_response.body.should == '/x.json' 
  end

  it "should ignore all requests except GET and HEAD" do
    put '/x'
    last_response.body.should == '/x' 
  end
end
