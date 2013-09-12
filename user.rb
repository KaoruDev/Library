# User class will hold information on each user, such as:
#
# - Username
# - Pin number (four-digit password) to verify actions
# - Answer to security question.
# - List of borrowed books.
# - Overdue books
# - Book status

class User
  attr_reader :username, :pin_num

  # overdue: if user has any overdue books, overdue = true
  # max_borrowed:if the number of books borrowed >= 2 max_borrowed = true
  # borrowed_books: list of books borrowed.
  # time_table will hold all the title of books borrowed and the time they are due.
  #
  # Records first and last name and pin number user sets.  
  attr_accessor :overdue, :max_borrowed, :borrowed_books, :time_table

  def initialize(username, pin_num)
    @username = username
    @pin_num = pin_num

    @borrowed_books = {}
    @overdue = false
    @max_borrowed = false
    @time_table = {}
  end

  #check_out will keep track of which books the user borrowed and the date it is due.

  def check_out(book, due_date)
    @borrowed_books[book.title.to_sym] = book
    max_borrowed = true if @borrowed_books.length >= 2

    time_table[book.title.to_sym] = due_date

  end

  # return will clear the user's record when book is returned.
  # If user has other books which are overdue it will set overdue = false

  def return(book_title)
    @borrowed_books.delete(book_title.to_sym)
    @time_table.delete(book_title.to_sym)

    time = Time.now

    if time_table == {}
      @overdue = false
    else
      time_table.each_value { |due_date|
        if time >= due_date
          @overdue = true
        end
      }
    end
  end

  # check_over_due is called by Library to check if any books are overdue
  def check_over_due
    time = Time.now
    @time_table.each{ |book, date|
      if date <= time
        puts "Bro #{book} is overdue"
        @overdue = true
      end
    }
  end

  #test over_due functionality by giving user a overdue book.
  def set_over_due(book)
    @borrowed_books[book.title.to_sym] = book
    time = Time.now - (60 * 60 * 24 * 30)

    @time_table[book.title.to_sym] = time
    puts "#{book.title} is now set to overdue"
  end

end