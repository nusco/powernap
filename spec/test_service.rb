require_relative '../lib/powernap'

class Book
  include PowerNap::Resource

  field :title, type: String

  def self.post
    'override'
  end
end

class Author
  include PowerNap::Resource

  only_responds_to :get, :put

  field :name, type: String
end
