require_relative '../lib/powernap'

class Book
  include PowerNap::Resource

  responds_to :get, :put

  field :title, type: String
end

class Empty
  include PowerNap::Resource
end
