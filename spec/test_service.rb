require_relative '../lib/powernap'

class Book
  include PowerNap::Mongoid
  
  field :title, type: String
end
PowerNap.resource Book

class Author
  include PowerNap::Mongoid

  private :get, :delete
  
  def post(body)
    "#{body}, #{name}!"
  end
  
  field :name, type: String
end
PowerNap.resource Author

class Review
  include PowerNap::Mongoid

  field :text, type: String
end
PowerNap.resource Review, :at => 'my/smart_reviews'

class Library
  include PowerNap::Mongoid

  def self.get
    'override'
  end
end
PowerNap.resource Library
