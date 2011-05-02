require_relative '../lib/powernap'

class MongoidBook
  include PowerNap::Mongoid
  
  field :title, type: String
end
PowerNap.resource MongoidBook

class MongoidAuthor
  include PowerNap::Mongoid

  private :get, :delete
  
  def post(body)
    "#{body}, #{name}!"
  end
  
  field :name, type: String
end
PowerNap.resource MongoidAuthor

class MongoidReview
  include PowerNap::Mongoid

  field :text, type: String
end
PowerNap.resource MongoidReview, :at => 'my/smart_reviews'

class MongoidLibrary
  include PowerNap::Mongoid

  def self.get
    'override'
  end
end
PowerNap.resource MongoidLibrary
