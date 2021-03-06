require "spec_helper"
require_relative "service"

describe "an HTTP resource" do
  include Rack::Test::Methods
  
  def app
    PowerNap.build_application do
      resource Book
      resource Author
      resource Review, :at_url => "my/smart_reviews"
    end
  end
  
  before :each do
    Book.DELETE
    Author.DELETE
  end
  
  it "should return 405 for Method Not Allowed" do
    post "/authors", '{"name": "Nusco"}'
    id = last_response.body
    get "/authors/#{id}"
    last_response.status.should == 405
    last_response.headers["Allow"].should == "POST, DELETE"
  end

  it "should generate default URLs" do
    post "/books", '{"title": "Metaprogramming Ruby"}'
    last_response.status.should == 201
  end

  it "should respect URLs set by the user" do
    post "/my/smart_reviews", '{"text": "A good read"}'
    id = last_response.body
    get "/my/smart_reviews/#{id}"
    last_response.status.should == 200
  end

  describe "when accessed with GET" do      
    before :each do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      @id = last_response.body
    end
  
    it "should get the resource as JSON when accessed without an extension" do
      get "/books/#{@id}"
      JSON.parse(last_response.body)["title"].should == "Metaprogramming Ruby"
    end
  
    it "should get the resource as JSON" do
      get "/books/#{@id}.json"
      JSON.parse(last_response.body)["title"].should == "Metaprogramming Ruby"
    end

    it "should return 415 for Unsupported Media Type" do
      get "/books/#{@id}.doc"
      last_response.status.should == 415
    end

    it "should return 200 for OK" do
      get "/books/#{@id}"
      last_response.status.should == 200
    end
  
    it "should return a Content-Length header" do
      get "/books/#{@id}.json"
      last_response.content_length.should == last_response.body.size
    end

    it "should return 404 for URL Not Found" do
      get "/books/whatever/123"
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      get "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      get "/dogs/12345"
      last_response.status.should == 404
    end
  end

  describe "when accessed with POST" do
    it "should do whatever the POST specifies" do
      post "/authors", '{"name": "Nusco"}'
      id = last_response.body
      post "/authors/#{id}", "Hello"
      last_response.body.should == "Hello, Nusco!"
    end

    it "should return 200 for OK" do
      post "/authors", '{"name": "Nusco"}'
      id = last_response.body
      post "/authors/#{id}", "Hello"
      last_response.status.should == 200
    end
  
    it "should return 404 for URL Not Found" do
      post "/books/whatever/123"
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      post "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      post "/dogs/12345"
      last_response.status.should == 404
    end
  end    

  describe "when accessed with PUT" do
    before :each do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      @id = last_response.body
    end
  
    it "should update a resource" do
      put "/books/#{@id}", '{"title": "Rails Recipes"}'
      get "/books/#{@id}"
      JSON.parse(last_response.body)["title"].should == "Rails Recipes"
    end

    it "should return 200 for OK" do
      put "/books/#{@id}", '{"title": "Rails Recipes"}'
      last_response.status.should == 200
    end

    it "should return 404 for URL Not Found" do
      put "/books/whatever/123", '{"title": "Rails Recipes"}'
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      put "/books/4daf5306c788e1d106000001", '{"title": "Rails Recipes"}'
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      put "/dogs/12345", '{"title": "Rails Recipes"}'
      last_response.status.should == 404
    end
  
    it "should return an Allow field when there is one in the request" do
      post "/authors", '{"name": "Paolo Perrotta"}'
      id = last_response.body
      header "Allow", "GET, POST"
      put "/authors/#{id}", '{"name": "Paolo Nusco Perrotta"}'
      last_response.headers["Allow"].should == "POST, DELETE"
    end
  end

  describe "when accessed with DELETE" do
    before :each do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      @id = last_response.body
    end

    it "should remove a resource" do
      delete "/books/#{@id}"
      get "/books/#{@id}"
      last_response.status.should == 404
    end

    it "should return 200 for OK" do
      delete "/books/#{@id}"
      last_response.status.should == 200
    end

    it "should return 404 for URL Not Found" do
      delete "/books/whatever/123"
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      delete "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      delete "/dogs/12345"
      last_response.status.should == 404
    end
  end

  describe "when accessed with OPTIONS" do
    before :each do
      post "/authors", '{"name": "Paolo Perrotta"}'
      @id = last_response.body
    end

    it "should return allowed methods in the Allow header field" do
      options "/authors/#{@id}"
      last_response.headers["Allow"].should == "POST, DELETE"
    end

    it "should return 200 for OK" do
      options "/authors/#{@id}"
      last_response.status.should == 200
    end

    it "should return 404 for URL Not Found" do
      options "/authors/whatever/123"
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      options "/authors/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      options "/dogs/12345"
      last_response.status.should == 404
    end
  end

  describe "when accessed with HEAD" do      
    before :each do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      @id = last_response.body
    end
  
    it "should get an empty body" do
      head "/books/#{@id}.json"
      last_response.body.should be_empty
    end

    it "should return 200 for OK" do
      head "/books/#{@id}"
      last_response.status.should == 200
    end
  
    it "should return the same Content-Length as a GET" do
      get "/books/#{@id}.txt"
      content_length = last_response.content_length
      head "/books/#{@id}.txt"
      last_response.content_length.should == content_length
    end
  
    it "should return 415 for Unsupported Media Type" do
      head "/books/#{@id}.doc"
      last_response.status.should == 415
    end
  
    it "should return 404 for URL Not Found" do
      head "/books/whatever/123"
      last_response.status.should == 404
    end

    it "should return 404 for resource Not Found" do
      head "/books/4daf5306c788e1d106000001"
      last_response.status.should == 404
    end

    it "should return 404 for resource type Not Found" do
      head "/dogs/12345"
      last_response.status.should == 404
    end

    it "should return 405 if GET is not allowed" do
      post "/authors", '{"name": "Nusco"}'
      id = last_response.body
      head "/authors/#{id}"
      last_response.status.should == 405
    end
  end
end

describe "an HTTP resource collection" do
  include Rack::Test::Methods

  attr_reader :app
  
  before :each do
    @app = PowerNap.build_application do
      resource Book
    end
  end

  describe "when accessed with GET" do
    before :each do
      post "/books", '{"title": "Metaprogramming Ruby"}'
    end
  
    it "should get a list of resources as JSON when accessed without an extension" do
      get "/books"
      JSON.parse(last_response.body)[0]["title"].should == "Metaprogramming Ruby"
    end
  
    it "should get a list of resources as JSON" do
      get "/books.json"
      JSON.parse(last_response.body)[0]["title"].should == "Metaprogramming Ruby"
    end

    it "should return 415 for Unsupported Media Type" do
      get "/books.doc"
      last_response.status.should == 415
    end

    it "should return 200 for OK" do
      get "/books"
      last_response.status.should == 200
    end
  
    it "should return a Content-Length header" do
      get "/books"
      last_response.content_length.should == last_response.body.size
    end

    it "should return 404 for resource type Not Found" do
      get "/dogs"
      last_response.status.should == 404
    end
  end
  
  describe "when accessed with POST" do
    it "should create a new resource and return its id in the body" do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      id = last_response.body
      get "/books/#{id}"
      last_response.status.should == 200
    end

    it "should return 201 for Created" do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      last_response.status.should == 201
    end

    it "should return 404 for resource type Not Found" do
      post "/dogs", '{"title": "Metaprogramming Ruby"}'
      last_response.status.should == 404
    end
  end
  
  describe "when accessed with DELETE" do
    it "should delete all resources" do
      post "/books", '{"title": "Metaprogramming Ruby"}'
      delete "/books"
      get "/books"
      JSON.parse(last_response.body).should be_empty
    end

    it "should return 404 for resource type Not Found" do
      delete "/dogs"
      last_response.status.should == 404
    end
  end

  describe "when accessed with OPTIONS" do
    it "should only support GET and POST" do
      options "/books"
      last_response.headers["Allow"].should == "GET, POST"
    end

    it "should return 200 for OK" do
      options "/books"
      last_response.status.should == 200
    end

    it "should return 404 for resource type Not Found" do
      options "/dogs"
      last_response.status.should == 404
    end
  end

  describe "when accessed with HEAD" do
      before :each do
        post "/books", '{"title": "Metaprogramming Ruby"}'
      end
    
      it "should get an empty body" do
        head "/books"
        last_response.body.should be_empty
      end

      it "should return 200 for OK" do
        head "/books"
        last_response.status.should == 200
      end

      it "should return the same Content-Length as a GET" do
        post "/books", '{"title": "Metaprogramming Ruby"}'
        get "/books"
        content_length = last_response.content_length
        head "/books"
        last_response.content_length.should == content_length
      end

      it "should return 415 for Unsupported Media Type" do
        head "/books.doc"
        last_response.status.should == 415
      end

      it "should return 404 for resource type Not Found" do
        head "/dogs"
        last_response.status.should == 404
      end
  end
end
