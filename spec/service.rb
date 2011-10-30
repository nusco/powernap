class Book
  include PowerNap::Resource

  attr_accessor :title
end

class Author
  include PowerNap::Resource

  private :GET, :PUT

  attr_accessor :name
  
  def POST(body)
    "#{body}, #{name}!"
  end
end

class Review
  include PowerNap::Resource
  
  attr_accessor :text
end
