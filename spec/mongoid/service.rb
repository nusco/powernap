class Book
  include PowerNap::Resource::Mongoid
  include Mongoid::Document
  
  field :title, type: String
end

class Author
  include PowerNap::Resource::Mongoid
  include Mongoid::Document

  private :get, :put
  
  def post(body)
    "#{body}, #{name}!"
  end
  
  field :name, type: String
end

class Review
  include PowerNap::Resource::Mongoid
  include Mongoid::Document
end
