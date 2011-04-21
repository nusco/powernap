require 'spec_helper'

describe PowerNap::Resource do
  it 'should be registered' do
    PowerNap.resources.should include Book 
  end

  it 'should respond to HTTP methods declared in only_responds_to' do
    Author.http_methods.should include :get, :put
  end

  it 'should not respond to HTTP methods not declared in only_responds_to' do
    Author.http_methods.should_not include :post
  end

  it 'should respond to all HTTP methods by default' do
    Book.http_methods.should include :get, :put, :post, :delete
  end
  
  it 'should also be a Mongoid document' do
    Book.ancestors.should include Mongoid::Document
  end
end
