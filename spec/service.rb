class Book
  include PowerNap::Resource

  has_field :title
  attr_accessor :title
end

class Author
  include PowerNap::Resource

  private :GET, :PUT

  has_field :name
  attr_accessor :name
  
  def POST(body)
    "#{body}, #{name}!"
  end
end

class Review
  include PowerNap::Resource
  
  has_field :text
  attr_accessor :test
end
