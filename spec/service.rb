class Book
  include PowerNap::Resource

  has_field :title
end

class Author
  include PowerNap::Resource

  has_field :name
  
  private :GET, :PUT

  def POST(body)
    "#{body}, #{name}!"
  end
end

class Review
  include PowerNap::Resource
  
  has_field :text
end
