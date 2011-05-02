require './lib/powernap'

class Book
  include PowerNap::Mongoid
  include Mongoid::Document
  
  field :title, type: String
end
PowerNap.resource Book

class Author
  include PowerNap::Mongoid
  include Mongoid::Document

  private :get, :put
  
  def post(body)
    "#{body}, #{name}!"
  end
  
  field :name, type: String
end
PowerNap.resource Author

class Review
  include PowerNap::Mongoid
  include Mongoid::Document
end
PowerNap.resource Review.at_url('my/smart_reviews')

class Library
  include PowerNap::Mongoid
  include Mongoid::Document

  def self.get
    'override'
  end
end
PowerNap.resource Library
