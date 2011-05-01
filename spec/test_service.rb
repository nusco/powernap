require_relative '../lib/powernap'

class Book
  include PowerNap::Resource
  
  field :title, type: String
end
PowerNap.resource Book

class Author
  include PowerNap::Resource

  responds_to :post, :put

  field :name, type: String
end
PowerNap.resource Author

class Comment
  include PowerNap::Resource

  field :text, type: String
end
PowerNap.resource Comment, :at => 'my/smart_comments'

class Library
  include PowerNap::Resource

  def self.get
    'override'
  end
end
PowerNap.resource Library
