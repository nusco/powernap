require 'spec_helper'

class SimpleResource
  extend PowerNap::Resource::ClassMethods

  private :delete
end
PowerNap.resource SimpleResource

class WriteOnlyResource
  extend PowerNap::Resource::ClassMethods

  private :get
end

describe PowerNap::Resource do
  it 'should allow public HTTP methods' do
    SimpleResource.allow_header().should == "GET, POST, PUT"
  end

  it 'should have a default URL' do
    WriteOnlyResource.url.should == 'writeonlyresources'
  end

  it 'should allow a custom URL' do
    SimpleResource.at_url('my_url').url.should == 'my_url'
  end
end
