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

  @collection = {} #Array that holds all of the books of the Library
  @users = {} #Array that holds registered users.

  require './book.rb'
  # Brings in Book class which will hold book's information such as
  # author, title, description, number of copies, ratings, reviews,
  # year published and edition.

  require './user.rb'
  # Brings in User class which will hold information on each user, such as:
  #
  # - Name
  # - Pin number (four-digit password) to verify actions
  # - Array of borrowed books.
  # - Overdue books
  # - Time borrowed, time due.


  def self.add_book(title, author, desc, num_copies, year, edition)
    # Creates a new book passing arguments to the Book class for storage.
    # Book class then Assigns and stores attributes
    #
    # title: Book title = String
    # author: Book title = String
    # desc: Book title = String
    # num_copies: How many copies of a book = FixNum
    # year: year published = FixNum
    # edition: what edition is the book? = FixNum
    #
    # Then it is added to the Library's collection.
    book = Book.new(title, author, desc, num_copies, year, edition)

    @collection[title.to_sym] = book
  end

  def self.add_user(username, pin_num, answer)
    # Creates a new user to hold information:
    #
    # - username: used to id user.
    # - pin_num: used to verify user
    # - answer: answer to security question incase user loses pin
    # NOTE: Secruity Question has not been created, since there is no output in program yet.
    user = User.new(username, pin_num, answer)

    @users[username.to_sym] = user
  end

  def self.check_out(book, user, pin)
    # Checks

  end


end