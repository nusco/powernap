require_relative "../lib/powernap"

class Book
  include PowerNap::Resource

  responds_to :get, :put
end

class Empty
  include PowerNap::Resource
end
