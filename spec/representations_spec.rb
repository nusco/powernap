require 'powernap/rack/representations'

require 'rack/lint'
require 'rack/test'
ENV['RACK_ENV'] = 'test'

describe Rack::Representations do
  include Rack::Test::Methods

  def app
    app = lambda { |env| [200, {'Content-Type' => 'text/html'}, ['{"message":"hello"}']] }
    Rack::Representations.new(app)
  end

  # FIXME: sucks. find a way to manage this correctly
  it "should do nothing if the extension is .json" do
    get '/my_resource.json'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end

  it "should do nothing if the URL has no extension" do
    get '/my_resource'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end

  it "should convert the body to the extension format" do
    get '/my_resource.txt'
    last_response.should be_ok
    last_response.body.should == 'message: hello'
  end

  it "should return a 415 for unsupported formats in a GET" do
    get '/my_resource.xml'
    last_response.status.should == 415
  end

  it "should return a 415 for unsupported formats in a HEAD" do
    head '/my_resource.xml'
    last_response.status.should == 415
  end
  
  # TODO: should it? really? also see the behavior in default_extension.rb
  it "should ignore all requests except GET and HEAD" do
    post '/my_resource.html'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end
end
