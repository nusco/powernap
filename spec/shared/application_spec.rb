require 'spec_helper'

describe "A PowerNap application" do
  include Rack::Test::Methods

  attr_reader :app
  
  before :each do
    @app = PowerNap.build_application
  end
  
  it 'should support OPTIONS on *' do
    options '*'
    last_response.should be_ok
  end

  it 'should not support OPTIONS on random URLs' do
    options 'whatever'
    last_response.status.should == 404
  end
end
