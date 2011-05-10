require 'spec_helper'

class SimpleResource
  extend PowerNap::Resource::ClassMethods

  def get; end
  def put; end
  
  private
  
  def delete; end
end

describe PowerNap::Resource do
  it 'should allow public HTTP methods' do
    SimpleResource.allow_header().should == "GET, PUT"
  end

  it 'should have a default URL' do
    SimpleResource.url.should == 'simpleresources'
  end

  it 'should allow a custom URL' do
    SimpleResource.url = 'my_url'
    SimpleResource.url.should == 'my_url'
  end
end
