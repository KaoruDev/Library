# class Book in book.rb will hold book's information such as
# author, title, description, number of copies, ratings, reviews,
# year published, edition, how many are checked-in, and how many are out.
class Book
  attr_reader :title, :author, :desc, :year, :edition


  attr_accessor :num_copies, :rating, :reviews, :num_in, :num_out, :borrowed_by

  # check_in keeps track of how many books are available
  # check_out keeps track of how many copies are out.
  # borrowed_by keeps track of who borrowed this book.

  # Runs whenever user adds a new book to Library.
  # Assigns and storees attributes
  #
  # title: Book title = String
  # author: Book title = String
  # desc: Book title = String
  # num_copies: How many copies of a book, default is 1 = FixNum
  # year: year published = FixNum
  # edition: what edition is the book? = FixNum
  def initialize(title, author, desc, year, edition, num_copies)
    @title = title
    @author = author
    @desc = desc
    @year = year
    @num_copies = num_copies
    @year = year
    @edition = edition

    @num_copies = num_copies
    @num_in = @num_copies
    @num_out = 0
    @borrowed_by = []
  end

  # If a user tries to add a book already in a collection,
  # dup_copy will increase availability.
  def dup_copy
    @num_copies += 1
    @num_in += 1

    puts "Great now we have #{@num_copies}!"
  end

  # Called when user checks out a book.
  # Will keep track of how many copies are left on the shelf, and how many are out.
  def check_out
    @num_in -= 1
    @num_out += 1

    puts "Inventory ERROR!!!!" if @num_out > @num_copies
  end

  # Stores who is borrowing this book.
  def check_out_by(user)
    borrowed_by.push(user)
  end

  # Refreshes book count and how many copies are available.
  def return
    @num_in += 1
    @num_out -= 1

    puts "Inventory ERROR!!!" if @num_in > @num_copies
  end

  # Cycles through users array and deletes user from list.
  def return_by(user)
    borrowed_by.map {|user_in_arr|
      if user_in_arr == user
        borrowed_by.delete(user)
      end
    }
  end

end