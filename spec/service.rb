class Book
  include PowerNap::Resource

  exposes :title
end

class Author
  include PowerNap::Resource

  exposes :name
  
  private :GET, :PUT

  def POST(body)
    "#{body}, #{name}!"
  end
end

class Review
  include PowerNap::Resource
  
  exposes :text
end
