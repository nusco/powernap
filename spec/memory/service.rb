require './lib/powernap'

class Book
  include PowerNap::Memory
end
PowerNap.resource Book

class Author
  include PowerNap::Memory

  private :get, :put
  
  def post(body)
    "#{body}, #{fields['name']}!"
  end
end
PowerNap.resource Author

class Review
  include PowerNap::Memory
end
PowerNap.resource Review.at_url('my/smart_reviews')

class Library
  include PowerNap::Memory

  def self.get
    'override'
  end
end
PowerNap.resource Library
