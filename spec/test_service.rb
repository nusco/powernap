require_relative '../lib/powernap'

class Book
  include PowerNap::Resource
  
  field :title, type: String
end
PowerNap.resource Book

class Author
  include PowerNap::Resource

  private :get, :delete
  
  def post(body)
    "#{body}, #{name}!"
  end
  
  field :name, type: String
end
PowerNap.resource Author

class Review
  include PowerNap::Resource

  field :text, type: String
end
PowerNap.resource Review, :at => 'my/smart_reviews'

class Library
  include PowerNap::Resource

  def self.get
    'override'
  end
end
PowerNap.resource Library
