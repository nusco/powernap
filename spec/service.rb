class Book
  include PowerNap::Resource
end

class Author
  include PowerNap::Resource

  private :GET, :PUT
  
  def POST(body)
    "#{body}, #{fields['name']}!"
  end
end

class Review
  include PowerNap::Resource
end
