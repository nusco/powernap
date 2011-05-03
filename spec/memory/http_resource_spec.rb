require 'spec_helper'
require_relative 'service'

puts 'Running in-memory tests...'

describe "An in-memory resource" do
  it_should_behave_like "any HTTP resource"
  it_should_behave_like "any HTTP resource collection"
end
