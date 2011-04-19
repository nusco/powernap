require 'spec_helper'

describe 'A PowerNap app' do
  include Rack::Test::Methods

  def app
    @app ||= PowerNap::APPLICATION
  end
  
  it 'should return 404 on an unknown resource' do
    get '/whatever'
    last_response.status.should == 404
  end
end
