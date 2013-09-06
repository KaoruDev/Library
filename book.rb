class Book
  # class Book in book.rb will hold book's information such as
  # author, title, description, number of copies, ratings, reviews,
  # year published, edition, how many are checked-in, and how many are out.

  attr_reader :title, :author, :desc, :year, :edition


  attr_accessor :num_copies, :rating, :reviews, :checked_in, :checked_out



  def initialize(title, author, desc, num_copies, year, edition)
    # Runs whenever user adds a new book to Library.
    # Assigns and storees attributes
    #
    # title: Book title = String
    # author: Book title = String
    # desc: Book title = String
    # num_copies: How many copies of a book = FixNum
    # year: year published = FixNum
    # edition: what edition is the book? = FixNum

    @title = title
    @author = author
    @desc = desc
    @year = year
    @num_copies = num_copies
    @year = year
    @edition = edition

    @num_copies =1
    @check_in = 1
  end

  def dup_copy
    # If a user tries to add a book already in a collection,
    # dup_copy will increase availability.
    @num_copies += 1
    @check_in += 1

    puts "Great now we have #{@num_copies}!"
  end

end