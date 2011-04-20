require 'spec_helper'

describe 'A PowerNap app' do
  include Rack::Test::Methods

  def app
    @app ||= PowerNap::APPLICATION
  end
  
  it 'should PUT anbd GET a resource' do
    put '/books', '{"title": "Metaprogramming Ruby"}'
    id = last_response.body
    get "/books/#{id}"
    JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
  end
  
  it 'should support OPTIONS on *' do
    options '*'
    last_response.should be_ok
  end
end
