require 'spec_helper'
require_relative 'service'

puts 'Running in-memory tests...'

describe "An in-memory resource" do
  def app
    PowerNap.build_application do
      resource Book
      resource Author
      resource Review, :at_url => 'my/smart_reviews'
    end
  end

  it_should_behave_like "any HTTP resource"
  it_should_behave_like "any HTTP resource collection"
end
