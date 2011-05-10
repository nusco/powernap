require 'spec_helper'

class Cat
  include PowerNap::Resource::Memory
end

describe PowerNap::Resource do
  describe 'the resource class' do
    it 'should post a new resource' do
      id = Cat.post '{"name": "Felix"}'
      Cat[id].name.should == 'Felix'
    end
  
    it 'should get all resources' do
      Cat.post '{"name": "Felix"}'
      Cat.post '{"name": "Grunt"}'
      all_cats = Cat.get
      all_cats[1]['name'] == 'Grunt'
    end
  
    it 'should have a serial id' do
      (Cat.next_id.to_i + 1).should == Cat.next_id.to_i
    end

    it 'should delete all resources' do
      Cat.post '{"name": "Felix"}'
      Cat.delete_all
      Cat.resources.should be_empty
    end
  end

  before :each do
    @r = Cat.new('{"name": "Felix", "age": 2}')
  end
  
  it 'should retrieve a resource with get() by default' do
    JSON.parse(@r.get)['name'].should == 'Felix'
  end
  
  it 'should update a resource with put(json) by default' do
    @r.put '{"name": "Felix", "age": 3}'
    @r.age.should == 3
  end
  
  it 'should remove a resource with delete() by default' do
    @r.delete
    Cat.resources.should be_empty
  end
  
  it 'should not have a default post()' do
    @r.methods.should_not include :post
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