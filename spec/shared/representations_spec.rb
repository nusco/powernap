require 'powernap/representations'

require 'rack/test'
ENV['RACK_ENV'] = 'test'

describe Rack::Representations do
  include Rack::Test::Methods

  def app
    app = lambda { |env| [200, {}, ['{"message":"hello"}']] }
    Rack::Representations.new app
  end

  # FIXME: sucks. find a way to manage this correctly
  it "should do nothing if the extension is .json" do
    get '/whatever.json'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end

  it "should do nothing if the URL has no extension" do
    get '/whatever'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end

  it "should return the body in the format specified by the request" do
    get '/whatever.txt'
    last_response.should be_ok
    last_response.body.should == 'message: hello'
  end

  it "should return a 415 for unsupported formats in a GET" do
    get '/whatever.xml'
    last_response.status.should == 415
  end

  it "should return a 415 for unsupported formats in a HEAD" do
    head '/whatever.xml'
    last_response.status.should == 415
  end
  
  # TODO: should it? really? also see the behavior in default_extension.rb
  it "should ignore all requests except GET and HEAD" do
    post '/x.html'
    last_response.should be_ok
    last_response.body.should == '{"message":"hello"}'
  end
end
