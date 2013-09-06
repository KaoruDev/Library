module Library
# Library module will be ableto keep track of books and their information.
#  -It will allow users to borrow AND return books.
#
#  -Users may add books of their own.
#
#  -It will keep track of which books they checked out.
#
#  -Users are limited to 2 books.
#
#  -If a user has one overdue book, they will not be able to borrow another.
#   until they have returned the first book.
# 
#  -Users can pull status reports showing them a list of books
#   and their status
# 
#  -Users may pull a status report on the books they have checked out
#   and how many days are left.
# 
#  -Users may pull the status of a specific book of their choosing.
# 
#  -Kaoru Kohashigawa > dev@kaoruk.com
# 

  require './book.rb'
  #class Book in book.rb will hold book's information such as
  # author, title, description, number of copies, ratings, reviews,
  # year published and edition.


  def self.add_book(title, author, desc, num_copies, year, edition)
    # Creates a new book passing arguments to the Book class for storage.
    # Book class then Assigns and stores attributes
    #
    # title - Book title = String
    # author - Book title = String
    # desc - Book title = String
    # num_copies - How many copies of a book = FixNum
    # year - year published = FixNum
    # edition - what edition is the book? = FixNum
    title = Book.new(title, author, desc, num_copies, year, edition)
  end


end