require 'spec_helper'

describe PowerNap do
  include Rack::Test::Methods

  def app
    PowerNap::APPLICATION
  end

  describe 'An HTTP service' do
    it 'should support OPTIONS on *' do
      options '*'
      last_response.should be_ok
    end

    it 'should not support OPTIONS on random URLs' do
      options 'whatever'
      last_response.status.should == 404 
    end
  end

  describe 'An HTTP resource' do
    before :each do
      Book.delete_all
      Author.delete_all
    end
    
    it 'should return 405 for Method Not Allowed' do
      post '/authors', '{"name": "Nusco"}'
      id = last_response.body
      get "/authors/#{id}"
      last_response.status.should == 405
      # TODO: test for Allowed header (from HTTP specs)
    end
    
    describe 'GET' do      
      before :each do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        @id = last_response.body
      end
      
      it 'should get the resource as JSON by default' do
        get "/books/#{@id}"
        JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
      end
      
      it 'should get the resource as JSON' do
        get "/books/#{@id}.json"
        JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
      end
      
      it 'can get the resource as XHTML' do
        get "/books/#{@id}.html"
        require 'nokogiri'
        last_response.body.should include "<p>Metaprogramming Ruby</p>"

        # TODO
        #Nokogiri::XML(last_response.body).xpath(boh).should == 'Metaprogramming Ruby'
      end
      
      it 'should return a 404 for unknown extensions' do
        get "/books/#{@id}.txt"
        last_response.status.should == 404
      end
    
      it 'should return 200 for OK' do
        get "/books/#{@id}"
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
    end

    describe "POST" do
      it 'should create a new resource' do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        id = last_response.body
        get "/books/#{id}"
        last_response.status.should == 200
      end
    end    
    
    describe "PUT" do
      it 'should update an existing resource' do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        id = last_response.body
        put "/books/#{id}", '{"title": "Rails Recipes"}'
        last_response.status.should == 200
        get "/books/#{id}"
        JSON.parse(last_response.body)['title'].should == "Rails Recipes"
      end
    end

    describe "DELETE" do
      it 'should remove a resource' do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        id = last_response.body
        delete "/books/#{id}"
        get "/books/#{id}"
        last_response.status.should == 404
      end
    end
  end
end
