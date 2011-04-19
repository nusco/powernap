require 'spec_helper'

describe PowerNap::Resource do
  it 'should be registered' do
    PowerNap.resources.should include Book 
  end

  it 'should respond to declared HTTP methods' do
    Book.http_methods.should include :get, :put
  end

  it 'should not respond to undeclared HTTP methods' do
    Book.http_methods.should_not include :delete
  end

  it 'could respond to no HTTP methods at all' do
    Empty.http_methods.should be_empty
  end
  
  it 'should also a Mongoid document' do
    Book.ancestors.should include Mongoid::Document
  end
end
