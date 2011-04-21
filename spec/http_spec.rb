require 'spec_helper'

describe PowerNap do
  include Rack::Test::Methods

  def app
    PowerNap::APPLICATION
  end

  describe 'A service' do
    it 'should support OPTIONS on *' do
      options '*'
      last_response.should be_ok
    end

    it 'should not support OPTIONS on random URLs' do
      options 'whatever'
      last_response.status.should == 404 
    end
  end

  describe 'A resource' do
    before :each do
      Book.delete_all
      Author.delete_all
    end

    it 'should understand PUT and GET' do
      put '/books', '{"title": "Metaprogramming Ruby"}'
      id = last_response.body
      get "/books/#{id}"
      JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
    end

    it 'should understand DELETE' do
      put '/books', '{"title": "Metaprogramming Ruby"}'
      id = last_response.body
      delete "/books/#{id}"
      get "/books/#{id}"
      last_response.status.should == 404
    end

    it 'should understand POST' do
      post '/books'
      last_response.status.should == 200
    end
    
    it 'should return 200 for OK' do
      put '/books', '{"title": "Metaprogramming Ruby"}'
      id = last_response.body
      get "/books/#{id}"
      last_response.status.should == 200
    end
    
    it 'should return 404 for URL Not Found' do
      get "/books/whatever/123"
      last_response.status.should == 404
    end
    
    it 'should return 404 for resource type Not Found' do
      get "/dogs/12345"
      last_response.status.should == 404
    end
    
    it 'should return 404 for resource Not Found' do
      get "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end
    
    it 'should return 405 for Method Not Allowed' do
      put '/authors', '{"name": "Nusco"}'
      id = last_response.body
      post "/authors"
      last_response.status.should == 405
      # TODO: test for Allowed header (from HTTP specs)
    end
  end
end
