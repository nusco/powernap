require 'spec_helper'
require_relative 'service'

puts 'Running in-memory tests...'

describe "An in-memory resource" do
  describe "when simple" do
    it_should_behave_like "any HTTP resource"
  end

  describe "when a collection" do
    it_should_behave_like "any HTTP resource collection"
  end
end