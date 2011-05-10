class Book
  include PowerNap::Resource::Memory
end

class Author
  include PowerNap::Resource::Memory

  private :get, :put
  
  def post(body)
    "#{body}, #{fields['name']}!"
  end
end

class Review
  include PowerNap::Resource::Memory
end
