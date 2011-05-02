require 'bundler/setup'
require './lib/powernap'

require 'rack/test'
ENV['RACK_ENV'] = 'test'

include Rack::Test::Methods

def app
  PowerNap::APPLICATION
end

require 'resource_spec'

shared_examples_for 'any HTTP resource' do
  before :each do
    Book.delete_all
    Author.delete_all
  end

  it 'should return 405 for Method Not Allowed' do
    post '/authors', '{"name": "Nusco"}'
    id = last_response.body
    get "/authors/#{id}"
    last_response.status.should == 405
    last_response.headers['Allow'].should == 'POST, PUT'
  end

  it 'should generate default URLs' do
    post '/books', '{"title": "Metaprogramming Ruby"}'
    last_response.status.should == 201
  end

  it 'should respect URLs set by the user' do
    post '/my/smart_reviews', '{"text": "A good read"}'
    id = last_response.body
    get "/my/smart_reviews/#{id}"
    last_response.status.should == 200
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
  
    it 'should return a Content-Length header' do
      get "/books/#{@id}.txt"
      last_response.content_length.should == last_response.body.size
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
    it 'should do whatever the post method specifies' do
      post '/authors', '{"name": "Nusco"}'
      id = last_response.body
      post "/authors/#{id}", 'Hello'
      last_response.body.should == 'Hello, Nusco!'
    end

    it 'should return 200 for OK' do
      post '/authors', '{"name": "Nusco"}'
      id = last_response.body
      post "/authors/#{id}", 'Hello'
      last_response.status.should == 200
    end
  
    it 'should return 404 for URL Not Found' do
      post "/books/whatever/123"
      last_response.status.should == 404
    end

    it 'should return 404 for resource Not Found' do
      post "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it 'should return 404 for resource type Not Found' do
      post "/dogs/12345"
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
  
    it 'should return an Allow field when there is one in the request' do
      post '/authors', '{"name": "Paolo Perrotta"}'
      id = last_response.body
      header 'Allow', 'GET, POST'
      put "/authors/#{id}", '{"name": "Paolo Nusco Perrotta"}'
      last_response.headers['Allow'].should == 'POST, PUT'
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

    it 'should return allowed methods in the Allow header field' do
      options "/authors/#{@id}"
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

  describe 'accessed with HEAD' do      
    before :each do
      post '/books', '{"title": "Metaprogramming Ruby"}'
      @id = last_response.body
    end
  
    it 'should get an empty body' do
      head "/books/#{@id}.json"
      last_response.body.should be_empty
    end

    it 'should return 200 for OK' do
      head "/books/#{@id}"
      last_response.status.should == 200
    end
  
    it 'should return the same Content-Length as a GET' do
      get "/books/#{@id}.txt"
      content_length = last_response.content_length
      head "/books/#{@id}.txt"
      last_response.content_length.should == content_length
    end
  
    it 'should return a 404 for unknown extensions' do
      head "/books/#{@id}.txt"
      last_response.status.should == 404
    end

    it 'should return 404 for URL Not Found' do
      head "/books/whatever/123"
      last_response.status.should == 404
    end

    it 'should return 404 for resource Not Found' do
      head "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it 'should return 404 for resource type Not Found' do
      head "/dogs/12345"
      last_response.status.should == 404
    end
  end
end

shared_examples_for 'any HTTP resource collection' do
  before :each do
    Book.delete_all
  end

  describe 'accessed with GET' do      
    before :each do
      post '/books', '{"title": "Metaprogramming Ruby"}'
    end
  
    it 'should get a list of resources as JSON when accessed without an extension' do
      get "/books"
      JSON.parse(last_response.body)[0]['title'].should == "Metaprogramming Ruby"
    end
  
    it 'should get the resource as JSON' do
      get "/books.json"
      JSON.parse(last_response.body)[0]['title'].should == "Metaprogramming Ruby"
    end
  
    it 'should get the resource as XHTML' do
      get "/books.html"
      require 'nokogiri'
      last_response.body.should include "<p>Metaprogramming Ruby</p>"

      # TODO
      #Nokogiri::XML(last_response.body).xpath(boh).should == 'Metaprogramming Ruby'
    end

    it 'should return 200 for OK' do
      get "/books"
      last_response.status.should == 200
    end
  
    it 'should return a Content-Length header' do
      get "/books"
      last_response.content_length.should == last_response.body.size
    end

    it 'should return 404 for resource Not Found' do
      get "/books/4daf5306c788e1d106000001"
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

    it 'should return 201 for Created' do
      post '/books', '{"title": "Metaprogramming Ruby"}'
      last_response.status.should == 201
    end

    it 'should return 404 for URL Not Found' do
      post "/books/whatever/123"
      last_response.status.should == 404
    end
  end    
end
