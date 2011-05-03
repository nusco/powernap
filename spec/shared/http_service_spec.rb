require 'spec_helper'

describe "An HTTP service" do
  it 'should support OPTIONS on *' do
    options '*'
    last_response.should be_ok
  end

  it 'should not support OPTIONS on random URLs' do
    options 'whatever'
    last_response.status.should == 404
  end
end
