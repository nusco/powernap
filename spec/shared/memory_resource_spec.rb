require 'spec_helper'

class Cat
  include PowerNap::Memory
end

describe PowerNap::Resource do
  before :each do
    @r = Cat.new('{"name": "Felix", "age": 2}')
  end
  
  it 'should have a serial id' do
    id      = Cat.new("{}").id
    next_id = Cat.new("{}").id
    
    next_id.to_i.should == id.to_i + 1
  end
  
  it 'should have field readers' do
    @r.age.should == 2
  end
  
  it 'should have field writers' do
    @r.age = 3
    @r.age.should == 3
  end
  
  it 'should behave as normal if you ask for something that is not a field' do
    lambda { @r.unknown }.should raise_error(NoMethodError)
  end
  
  it 'should fail fast if a field name conflicts with a method in Object' do
    lambda {
      Cat.new('{"name": "Felix", "clone": "Boom!"}')
    }.should raise_error do |e|
      e.message.should == 'Field "clone" clashes with method clone() in Cat.'
    end
  end
  
  it 'should fail fast if a field name conflicts with a method in BasicObject' do
    lambda {
      Cat.new('{"name": "Felix", "instance_eval": "Boom!"}')
    }.should raise_error do |e|
      e.message.should == 'Reserved field name: "instance_eval".'
    end
  end
end
