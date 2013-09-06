class User
  # User class will hold information on each user, such as:
  #
  # - Username
  # - Pin number (four-digit password) to verify actions
  # - Answer to security question.
  # - List of borrowed books.
  # - Overdue books
  # - Book status

  attr_reader :username, :pin_num
  
  attr_accessor :overdue 
  attr_accessor :max_borrowed 
  attr_accessor :borrowed_books 
  

  # overdue: if user has any overdue books, overdue = true
  # max_borrowed:if the number of books borrowed >= 2 max_borrowed = true
  # borrowed_books: list of books borrowed.

  def initialize(username, pin_num, answer)
    # Records first and last name and pin number user sets.
    @username = username
    @pin_num = pin_num

    @borrowed_books = {}
    @overdue = false
    @max_borrowed = false
  end

  def check_out(book)
    @borrowed_books[book.title.to_sym] = book
    max_borrowed = true if @borrowed_books.length >= 2
  end

  def return(book_title)
    @borrowed_books.delete(book_title.to_sym)
  end

end