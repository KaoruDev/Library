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

  @collection = {} #Keeps track of all books
  @users = {} #Keeps track of all users

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

  # csv to add CSV functionality
  require 'csv'


  def self.add_book(title, author, desc, year, edition, num_copies = 1)
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

    if @collection != {} && @collection[title.to_sym]
      # If a user tries to add a book already in a collection, 
      # dup_copy will simply increase the number of available books.
      @collection[title.to_sym].dup_copy
    else
      book = Book.new(title, author, desc, year, edition, num_copies)
      @collection[title.to_sym] = book
    end
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


  def self.list
    # Prints a list of books, how many copies there are, how many copies are checked out,
    # who they are checked out by, and how many are available.

    print %<
    Title\tAuthor\t\tChecked In\tChecked Out\t>
    @collection.each { |name, book|
      print %<
      #{book.title}\t#{book.author}\t\t#{book.num_in}\t\t#{book.num_out}
      >
    }
  end

  def self.info_on(book_title)
    # Prints out more information on a specific book.
    # Title, Author, Description, Year published, Edition, How many avaiable.
    look_up = @collection[book_title.to_sym]
    print %<
      Title:             #{look_up.title}
      Author:            #{look_up.author}
      Description:       #{look_up.desc}
      Published year:    #{look_up.year}
      Edition:           #{look_up.edition}
      Number Available:  #{look_up.num_in}
     >
  end

  def self.my_books(user)
    # prints out of a list of books that you have checked out.
    puts %<
    Here is a list of books you currently have checked_out>

    if @users[user.to_sym] && @users[user.to_sym].borrowed_books.length > 0
      @users[user.to_sym].borrowed_books.each {|key, value|
        puts %<
        - #{value.title}>
      }
    else

    end
  end

  # check_out stamps a book for check out.
  # Requires book_title = string
  # verifies user (string) and pin (interger)

  def self.check_out(book_title, user, pin)

    # Verifies if the book is in @collection, if user has an account and correct pin number, the book is available,
    # the user has no overdue books or has 2 books borrowed. If true, sends information to both book and user class
    # to update changes. 
    if @collection[book_title.to_sym] && @users[user.to_sym] && @users[user.to_sym].pin_num == pin && @collection[book_title.to_sym].num_in >=1 && !@users[user.to_sym].overdue && !@users[user.to_sym].max_borrowed
      due_date = Time.now + (60 * 60 * 24 * 7)
  
      puts "You can borrow #{book_title}!"
      @collection[book_title.to_sym].check_out
      @collection[book_title.to_sym].check_out_by(user)
      @users[user.to_sym].check_out(@collection[book_title.to_sym], due_date)
    else
      puts "You may not borrow this book!"
    end
  end

  def self.return(book_title, user, pin)
    # returns book to library.
    # user is converted to a symbol to access hash key in @users to determine who user is.
    
    if @users[user.to_sym].borrowed_books[book_title.to_sym]  && @users[user.to_sym].pin_num == pin
      # Verifies if user has a this specific book checked out.
      # Verifies user's pin number. If both are true,
      # user's record is cleared, and book count is returned to collection.

      @collection[book_title.to_sym].return
      @collection[book_title.to_sym].return_by(user)
      @users[user.to_sym].return(book_title)

      puts "Book returned!"

    else
      puts "I'm sorry I didn't get that, try again."
    end
  end

  # Checks through @users to find any user who has a book that is overdue.

  def self.check_over_due
    @users.each_value {|user|
      if user.time_table != {} && !user.overdue && !user.max_borrowed
        user.check_over_due
      end
    }
  end

  #Test over due by setting a book that is over due on purpose.
  def self.test_over_due(book_title, user)
    @users[user.to_sym].set_over_due(@collection[book_title.to_sym])
  end

  # Creates a CSV file "Collection.csv" with a list of books in the library.
  def self.create_list
    header = ["Title", "Author"]

    CSV.open("Collection.csv", "ab"){|csv|
      csv << header
    }

    @collection.each_value {|book|
      current_book = []
      current_book.push (book.title)
      current_book.push (book.author)
      CSV.open("Collection.csv", "ab"){ |csv|
        csv << current_book
      }
    }
  end

end


Library.add_book("Fish", "author", "desc", "year", "edition")
Library.add_book("Fish", "author", "desc", "year", "edition")
Library.add_book("Fish", "author", "desc", "year", "edition")
Library.add_book("LOTR", "author", "desc", "year", "edition", 4)
Library.add_user("Bob", 4821, "answer")
Library.add_user("Goat", 0000, "answer")

Library.check_out("Fish", "Bob", 4821)
Library.return("Fish", "Bob", 4821)

Library.list
Library.info_on("Fish")

Library.check_out("LOTR", "Goat", 0000)
Library.my_books("Goat")

Library.test_over_due("LOTR", "Bob")
Library.check_over_due






