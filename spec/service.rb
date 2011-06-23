class Book
  include PowerNap::Resource
end

class Author
  include PowerNap::Resource

  private :get, :put
  
  def post(body)
    "#{body}, #{fields['name']}!"
  end
end

class Review
  include PowerNap::Resource
end
