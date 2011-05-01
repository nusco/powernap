require_relative '../lib/powernap'

class Book
  include PowerNap::Resource
  
  field :title, type: String
end

class Author
  include PowerNap::Resource

  responds_to :post, :put

  field :name, type: String
end

class Comment
  include PowerNap::Resource

#  def self.url
#    'my_comments'
#  end
  
  field :text, type: String
end

class Library
  include PowerNap::Resource

  def self.get
    'override'
  end
end
