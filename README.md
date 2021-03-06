# PowerNap

PowerNap is a low-friction REST framework for web services.

_PowerNap is a toy project I use to try out a few ideas. It's just an experiment. Don't build your next world-changing social network on this._

* [![Build Status](https://travis-ci.org/nusco/powernap.png)](https://travis-ci.org/nusco/powernap)
* [![Dependencies Status](https://gemnasium.com/nusco/powernap.png?travis)](https://gemnasium.com/nusco/powernap)

## Installing PowerNap

Not yet. Just clone this repo.
  
## Put that Resource on the Web

### *Step One* - define a Ruby class:

  	class Book
      include PowerNap::Resource
  	end

### *Step Two* - create an application for your resource:

  	app = PowerNap.build_application do
      resource Book
  	end

### *Step Three* - expose the application on the web:

The PowerNap application is just a regular Sinatra application (see http://www.sinatrarb.com/intro.html#Serving%20a%20Modular%20Application). So you can launch it via Rack, or whatever.

OK, now you can talk to your app. It talks JSON by default. It contains two resources: books and lists of books. So you get these URLS:

    GET  books/        # retrieve a list of all books
    POST books/        # insert a new book. the request body must contain the book as JSON.
                     # the response body contains the id of the new resource
    DELETE books/      # deletes all books

    GET    books/<id>  # returns the book in the response body (as JSON)
    PUT    books/<id>  # changes the fields of the book with id 1. the request body must contain the fields as JSON
    DELETE books/<id>  # deletes the book with id

For example:

    POST books/ '{"title": "Metaprogramming Ruby", "author": "Nusco"}'

If the previous POST returned 42 in the body, then:

    GET books/42
  
will retrieve the book.
  
You can also send OPTIONS and HEAD to both resources.

## HTML and Other Formats

_todo_

## Resources as Business Model

Create a resource with a piece of JSON:

_todo_

Resources are open structures, so you can access their fields through regular method accessors.

Feel free to add your business logics to PowerNap resources. Anemic objects are sad.

## Customized Verbs

If you want to limit the HTTP verbs that a resource allows, just make them private:

    class Author
      include PowerNap::Resource::Memory
    
      private :DELETE
    end

If you want your own behavior for a verb, just define or override it:

    class Library
      include PowerNap::Resource::Memory
  
      def POST
        "my own POST"
      end

      def GET
        ["An override", "of GET"].to_json
      end
    end

Feel free to come up with your own overrides for HTTP verbs. Just respect PowerNap's basic expectations: GET on a resource is always supposed to return the resource as JSON, PUT takes JSON and returns an id in the response body, and so on.

## License

_todo_
