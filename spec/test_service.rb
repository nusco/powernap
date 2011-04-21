require_relative '../lib/powernap'

class Book
  include PowerNap::Resource

  field :title, type: String
end

class Author
  include PowerNap::Resource

  only_responds_to :get, :post

  field :name, type: String

  def self.post
    'override'
  end
end
