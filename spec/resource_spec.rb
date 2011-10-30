require 'spec_helper'

class Cat
  include PowerNap::Resource
  
  def genus; 'Felis'; end
  
  def tag=(value)
    @tag = "TAG:#{value}"
  end

  exposes :name, :age, :genus, :tag
end

describe PowerNap::Resource do
  describe 'the resource class' do
    it 'should post a new resource' do
      id = Cat.POST '{"name": "Felix"}'
      Cat[id].name.should == 'Felix'
    end
  
    it 'should get all resources' do
      Cat.POST '{"name": "Felix"}'
      Cat.POST '{"name": "Grunt"}'
      all_cats = Cat.GET
      all_cats[1]['name'] == 'Grunt'
    end
  
    it 'should have a serial id' do
      (Cat.next_id.to_i + 1).should == Cat.next_id.to_i
    end

    it 'should delete all resources' do
      Cat.POST '{"name": "Felix"}'
      Cat.DELETE
      Cat.resources.should be_empty
    end
  end

  before :each do
    @r = Cat.new({"name" => 'Felix', "age" => 2})
  end
  
  it 'should retrieve a resource with GET() by default' do
    @r.GET[:name].should == 'Felix'
  end
  
  it 'the representation of the resource should include its id' do
    @r.GET[:id].should == @r.id
  end
  
  it 'should update a resource with PUT(json) by default' do
    @r.PUT '{"name": "Felix", "age": 3}'
    @r.age.should == 3
  end
  
  it 'should remove a resource with DELETE() by default' do
    @r.DELETE
    Cat.resources.should be_empty
  end
  
  it 'should not have a default POST()' do
    @r.methods.should_not include :post
  end
  
  it 'should have a serial id' do
    id      = Cat.new({}).id
    next_id = Cat.new({}).id
    
    next_id.to_i.should == id.to_i + 1
  end
  
  it 'should have field readers' do
    @r.age.should == 2
  end
  
  it 'should have field writers' do
    @r.age = 3
    @r.age.should == 3
  end
  
  it 'should not overwrite existing field readers' do
    resource = Cat.new({"genus" => "Canis"})
    resource.genus.should == "Felis"
  end
  
  it 'should not overwrite existing field writers' do
    resource = Cat.new({"tag" => "my_cat"})
    resource.tag.should == "TAG:my_cat"
  end
  
  # TODO: decide what happens when you try to create a resource with an undeclared field
end
