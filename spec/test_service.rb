require_relative '../lib/powernap'

class Book
  include PowerNap::Resource

  field :title, type: String
end

class Author
  include PowerNap::Resource

  only_responds_to :post

  field :name, type: String
end

class Library
  include PowerNap::Resource

  def self.get
    'override'
  end
end
