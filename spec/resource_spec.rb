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
  it 'should authorize HTTP methods by default' do
    lambda { SimpleResource.authorize(:post) }.should_not raise_exception
  end

  it 'should not authorize private HTTP methods' do
    lambda {
      SimpleResource.authorize(:delete)
    }.should raise_exception(PowerNap::HttpException) {|e|
      e.message.should == [405, {'Allow' => "GET, POST, PUT"}, []]
    }
    # FIXME: apparently, using do..end above means that the block is never
    # executed. investigate. bug in ruby 1.9.2?
  end

  it 'should always authorize OPTIONS' do
    lambda { SimpleResource.authorize(:options) }.should_not raise_exception
  end

  it 'should allow HEAD if GET is allows' do
    lambda { SimpleResource.authorize(:head) }.should_not raise_exception
  end

  it 'should not allow HEAD if GET is not allowed' do
    lambda {
      WriteOnlyResource.authorize(:head)
    }.should raise_exception(PowerNap::HttpException) {|e|
      e.message.should == [405, {'Allow' => "POST, PUT, DELETE"}, []]
    }
  end

  it 'should have a default URL' do
    SimpleResource.url.should == 'simpleresources'
  end

  it 'should allow a custom URL' do
    SimpleResource.at_url('my_url').url.should == 'my_url'
  end
end
