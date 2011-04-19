require 'spec_helper'

describe 'A PowerNap app' do
  include Rack::Test::Methods

  def app
    @app ||= PowerNap::APPLICATION
  end
  
  it 'should ' do
    get '/'
    last_response.should be_ok
  end
end
