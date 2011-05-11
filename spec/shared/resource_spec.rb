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
end
