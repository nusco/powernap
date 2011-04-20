require_relative '../lib/powernap'

class Book
  include PowerNap::Resource

  responds_to :get, :put, :delete

  field :title, type: String
end

class Author
  include PowerNap::Resource

  responds_to :get, :put

  field :name, type: String
end

class Empty
  include PowerNap::Resource
end
