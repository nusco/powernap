require 'spec_helper'

describe PowerNap::Resource do
  before :each do
    Book.delete_all
    Author.delete_all
  end

  it 'should be registered' do
    PowerNap.resource_classes.should include Book 
  end

  it 'should respond to HTTP methods declared in only_responds_to' do
    Author.http_methods.should include :get, :post
  end

  it 'should not respond to HTTP methods not declared in only_responds_to' do
    Author.http_methods.should_not include :put
  end

  it 'should respond to all HTTP methods by default' do
    Book.http_methods.should include :get, :put, :post, :delete
  end

  it "should have the default HTTP methods" do
    id = Book.post '{"title": "Metaprogramming Ruby"}'
    Book.get(id).should_not be_nil
  end
  
  it 'can override HTTP methods' do
    Author.post.should == "override"
  end
  
  it 'should also be a Mongoid document' do
    Book.ancestors.should include Mongoid::Document
  end
end
