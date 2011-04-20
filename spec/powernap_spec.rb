require 'spec_helper'

describe 'A PowerNap app' do
  include Rack::Test::Methods

  def app
    @app ||= PowerNap::APPLICATION
  end
  
  it 'should support OPTIONS on *' do
    options '/'
    last_response.should be_ok
  end
end
