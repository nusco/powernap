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
    
    describe 'accessed with GET' do      
      before :each do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        @id = last_response.body
      end
      
      it 'should get the resource as JSON when accessed without an extension' do
        get "/books/#{@id}"
        JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
      end
      
      it 'should get the resource as JSON' do
        get "/books/#{@id}.json"
        JSON.parse(last_response.body)['title'].should == "Metaprogramming Ruby"
      end
      
      it 'should get the resource as XHTML' do
        get "/books/#{@id}.html"
        require 'nokogiri'
        last_response.body.should include "<p>Metaprogramming Ruby</p>"

        # TODO
        #Nokogiri::XML(last_response.body).xpath(boh).should == 'Metaprogramming Ruby'
      end
    
      it 'should return 200 for OK' do
        get "/books/#{@id}"
        last_response.status.should == 200
      end
      
      it 'should return a 404 for unknown extensions' do
        get "/books/#{@id}.txt"
        last_response.status.should == 404
      end
    
      it 'should return 404 for URL Not Found' do
        get "/books/whatever/123"
        last_response.status.should == 404
      end
    
      it 'should return 404 for resource Not Found' do
        get "/books/4daf5306c788e1d106000001"
        last_response.status.should == 404
      end
    
      it 'should return 404 for resource type Not Found' do
        get "/dogs/12345"
        last_response.status.should == 404
      end
    end

    describe "accessed with POST" do
      it 'should create a new resource and return its id in the body' do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        id = last_response.body
        get "/books/#{id}"
        last_response.status.should == 200
      end

      it 'should return 200 for OK' do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        last_response.status.should == 200
      end
    
      it 'should return 404 for URL Not Found' do
        post "/books/whatever/123"
        last_response.status.should == 404
      end
    end    
    
    describe 'accessed with PUT' do
      before :each do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        @id = last_response.body
      end
      
      it 'should update an existing resource' do
        put "/books/#{@id}", '{"title": "Rails Recipes"}'
        last_response.status.should == 200
        get "/books/#{@id}"
        JSON.parse(last_response.body)['title'].should == "Rails Recipes"
      end
  
      it 'should return 200 for OK' do
        put "/books/#{@id}", '{"title": "Rails Recipes"}'
        last_response.status.should == 200
      end
  
      it 'should return 404 for URL Not Found' do
        put "/books/whatever/123", '{"title": "Rails Recipes"}'
        last_response.status.should == 404
      end
  
      it 'should return 404 for resource Not Found' do
        put "/books/4daf5306c788e1d106000001", '{"title": "Rails Recipes"}'
        last_response.status.should == 404
      end
  
      it 'should return 404 for resource type Not Found' do
        put "/dogs/12345", '{"title": "Rails Recipes"}'
        last_response.status.should == 404
      end
    end

    describe 'accessed with DELETE' do
      before :each do
        post '/books', '{"title": "Metaprogramming Ruby"}'
        @id = last_response.body
      end

      it 'should remove a resource' do
        delete "/books/#{@id}"
        get "/books/#{@id}"
        last_response.status.should == 404
      end

      it 'should return 200 for OK' do
        delete "/books/#{@id}"
        last_response.status.should == 200
      end

      it 'should return 404 for URL Not Found' do
        delete "/books/whatever/123"
        last_response.status.should == 404
      end

      it 'should return 404 for resource Not Found' do
        delete "/books/4daf5306c788e1d106000001"
        last_response.status.should == 404
      end

      it 'should return 404 for resource type Not Found' do
        delete "/dogs/12345"
        last_response.status.should == 404
      end
    end

    describe 'accessed with OPTIONS' do
      before :each do
        post '/authors', '{"name": "Paolo Perrotta"}'
        @id = last_response.body
      end

      it 'should return allowed in the Allow header field' do
        options "/authors/#{@id}"
        last_response.status.should == 200 # REMOVEME
        last_response.headers['Allow'].should == 'POST, PUT'
      end

      it 'should return 200 for OK' do
        options "/authors/#{@id}"
        last_response.status.should == 200
      end

      it 'should return 404 for URL Not Found' do
        options "/authors/whatever/123"
        last_response.status.should == 404
      end

      it 'should return 404 for resource Not Found' do
        options "/authors/4daf5306c788e1d106000001"
        last_response.status.should == 404
      end

      it 'should return 404 for resource type Not Found' do
        options "/dogs/12345"
        last_response.status.should == 404
      end
    end
  end
end
