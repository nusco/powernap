require 'spec_helper'

describe 'A service' do
  include Rack::Test::Methods

  def app
    PowerNap::APPLICATION
  end

  it 'should support OPTIONS *' do
    options '*'
    last_response.should be_ok
  end
end

describe 'A resource' do
  include Rack::Test::Methods

  def app
    PowerNap::APPLICATION
  end

  before :each do
    Book.delete_all
  end
  
  it 'should understand PUT and GET' do
    put '/books', '{"title": "Metaprogramming Ruby"}'
    id = last_response.body
    get "/books/#{id}"
    JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
  end
end
