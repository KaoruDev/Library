# Library module will be able to keep track of books and users.
#
# verify_user & verify_book verifies if user and book is in the database.
#
# add_book creates a new book class. Library keeps track of instance via collection hash via title.
#
# add_user creates a new user class. Library keeps track of instance via users hash via name.
#
# list prints a detailed list of books in the collection hash.
#
# info_on prints all information about a specific book.
#
# my_books prints a lists of borrowed books of a specific user.
#
# check_out allows registered users to borrow a specific book.
# 
# return allows registered users to return a specific book.
#
# check_over_due sets any books overdue.
#
# test_over_due sets a specific book overdue to test other methods.
#
# create_book_lists creates a csv file with a list of books currently in the collection.
#
# import_book_list imports a csv and adds the books in the collection hash.
#
# write_review and read_review allows anyone to write/read reviews and ratings of a book.
#
# future_check_out allows users to schedule a future check out if book is currently not available.

module Library


  @collection = {} #Keeps track of all books
  @users = {} #Keeps track of all users

  # Brings in Book class which will hold book's information such as
  # author, title, description, number of copies, ratings, reviews,
  # year published and edition.
  require './book.rb'

  # Brings in User class which will hold information on each user, such as:
  #
  # - Name
  # - Pin number (four-digit password) to verify actions
  # - Array of borrowed books.
  # - Overdue books
  # - Time borrowed, time due.
  require './user.rb'

  # csv to add CSV functionality
  require 'csv'

  # Verifies if user and book exist in database. Returns nil if they don't
  #
  # Library.verify_user("Marley")
  #   if "Marley" exists systems puts "You are registered"
  #   else puts You are not registed in our system! 
  def self.verify_user(username)
    if @users != {}
      @users.each_key{ |user_key|
      if user_key == username.to_sym
        puts "#{username}, you are registered in system."
      end
      }
    else
      puts "You are not registered in our system!"
    end
  end

  # Verifies if user and book exist in database. Returns nil if they don't
  #
  # Library.verify_book("LOTR")
  #   if "LOTR" exists systems puts "You are registered"
  #   else puts You are not registered in our system! 

  def self.verify_book(book_title)
    if @collection != {}
      @collection.each_key{ |book_key|
      if book_key == book_title.to_sym
        puts "#{book_title} is in our collection."
      end
      }
    else
      puts "No such book exists in our collection!" 
    end
  end

  # Creates a new book passing arguments to the Book class for storage.
  # Book class then Assigns and stores attributes
  #
  # Library.add_book("LOTR", "JJR Tokens", "desc of book", "2004", "edition", "4")
  # => creates a book class with the arguments and stores it in @collection hash using the title as the key.
  def self.add_book(title, author, desc, year, edition, num_copies = 1)

    # If a user tries to add a book already in a collection, 
    # dup_copy will simply increase the number of available books.
    if @collection != {} && @collection[title.to_sym]
      @collection[title.to_sym].dup_copy
    else
      book = Book.new(title, author, desc, year, edition, num_copies)
      @collection[title.to_sym] = book
    end
  end

  # Creates a new user to hold information:
  #
  # Library.add_user("Styles", 4325)
  # => creates a user class with user.name = "Styles" and user.pin_num = 4325
  # Adds new user class to @users hash using name as the key.
  #
  def self.add_user(username, pin_num)
    
    if @users != {} && @users[username.to_sym]
      puts "Sorry, #{username} is taken."
    else
      user = User.new(username, pin_num)

      @users[username.to_sym] = user
    end
  end

  # Prints a lists of books currently in the collection.
  #
  # Library.list
  # => Title: LOTR
  # => Author: JJR Tokens
  # => Checked In: 4
  # => Checked Out: 0
  #
  def self.list

    @collection.each { |name, book|
      print %<
      Title: #{book.title}
      Author: #{book.author}
      Checked In: #{book.num_in}
      Checked Out: #{book.num_out}
      >
    }
  end

  # Prints out more information on a specific book.
  # Title, Author, Description, Year published, Edition, How many avaiable.
  # Library.info_on("LOTR")
  # => Title: LOTR
  # => Author: JJR Tokens
  # etc..
  #
  def self.info_on(book_title)
    look_up = @collection[book_title.to_sym]
    print %<
      Title:              #{look_up.title}
      Author:             #{look_up.author}
      Description:        #{look_up.desc}
      Published year:     #{look_up.year}
      Edition:            #{look_up.edition}
      Number Available:   #{look_up.num_in}
     >
  end

  # Prints out of a list of books that you have checked out.
  # 
  # Library.user("Marley")
  # => Here is a list of books you currently have checked out
  # => "LOTR"
  # => etc..
  #
  def self.my_books(user)
    puts %<
    Here is a list of books you currently have checked out>

    if @users[user.to_sym] && @users[user.to_sym].borrowed_books.length > 0
      @users[user.to_sym].borrowed_books.each {|key, value|
        puts %<
        - #{value.title}>
      }
    else

    end
  end

  # Check out stamps a book for check out.
  # Requires book_title = string
  # verifies user (string) and pin (interger)
  # Library.check_out("LOTR", "Marley", 4325)
  #

  def self.check_out(book_title, username, pin)
    # Verifies if the book is in @collection, if user has an account and has entered the correct pin, the book is available,
    # the user has no overdue books or has reach the borrowing limit. If true, sends information to both book and user class
    # to update changes. 
    search_results = false
    current_book, current_user = nil

    if @collection != {} && @users != {}
      @collection.each_key{ |book_key|
        if book_key == book_title.to_sym
          current_book = @collection[book_key]
        end
      }
      @users.each_key{ |user_key|
        if user_key == username.to_sym
          current_user = @users[username.to_sym]
        end
      }
    end

    if current_book && current_user && current_book.num_in >=1 && !current_user.overdue && !current_user.max_borrowed && current_user.pin_num == pin
      due_date = Time.now + (60 * 60 * 24 * 7)
      puts "#{username}, you have checked out #{book_title}. It is due on #{due_date.strftime("%A, %B %d, %Y")}"

      current_book.check_out
      current_book.check_out_by(current_user)
      current_user.check_out(current_book, due_date)
    else
      puts "You have to register before you may borrow books." unless current_user
      puts "There is no such book." unless current_book
      if current_book && current_user
        puts "You may not borrow #{book_title} because you have an overdue book" if current_user.overdue
        puts "You may not borrow #{book_title} because your borrow limit has been reached." if current_user.max_borrowed
        puts "There is no available copy of #{book_title} for you to borrow" if current_book.num_in < 1
        puts "Sorry you entered the wrong pin number." if current_user.pin_num == pin
      end
    end
  end

  # returns book to library.
  # user is converted to a symbol to access hash key in @users to determine who user is.
  # Library.return("LOTR", "Marley")
  def self.return(book_title, user, pin)
    # Verifies if user has a this specific book checked out.
    # Verifies user's pin number. If both are true,
    # user's record is cleared, and book count is returned to collection.
    if @users[user.to_sym].borrowed_books[book_title.to_sym]  && @users[user.to_sym].pin_num == pin

      @collection[book_title.to_sym].return
      @collection[book_title.to_sym].return_by(user)
      @users[user.to_sym].return(book_title)

      puts "Book returned!"

    else
      puts "I'm sorry I didn't get that, try again."
    end
  end

  # Checks through @users to find any user who has a book that is overdue.
  # Library.check_over_due

  def self.check_over_due
    @users.each_value {|user|
      if user.time_table != {} && !user.overdue && !user.max_borrowed
        user.check_over_due
      end
    }
  end


  # Test over due by setting a book that is over due on purpose.
  # Library.test_over_due("LOTR", "Marley")
  # => sets LOTR in user to be overdue by a week.
  def self.test_over_due(book_title, user)
    @users[user.to_sym].set_over_due(@collection[book_title.to_sym])
  end



  # Creates a CSV file "Collection.csv" with a list of books in the library.
  # Library.create_book_list
  #
  def self.create_book_list
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

  # Pulls in a csv file and adds it to the book collection.
  # csv_file = filename of CSV file that users wish to import
  def self.import_book_list(csv_file)
    csv = CSV.read(csv_file, {
      headers: true,
      header_converters: :symbol
      })
    csv.each{ |row|
      self.add_book("#{row[:title]}", "#{row[:author]}", "#{row[:desc]}", "#{row[:year]}", "#{row[:edition]}", "#{row[:num_copies]}")
    }
  end

  # Writes a review for a book. Passes a string and a 1-5 rating for the book.
  # Library.write_review("LOTR", 4, "Awesome")
  def self.write_review(book_title, rating, review)
    @collection[book_title.to_sym].write_review(rating, review)
  end

  # Prints book reviews and rating value.
  # Library.read_review("LOTR")
  def self.read_review(book_title)
    @collection[book_title.to_sym].read_review
  end

  # Enables users to schedule future check_outs
  # book_title: String - Used to pull book object in @collection array
  # username: String - Used to store who is scheduling a future check out.
  # Library.future_check_out("LOTR", "Marley")
  def self.future_check_out(book_title, username)
    current_user, current_book = nil

    if @collection != {} && @users != {}
      @collection.each_key{ |book_key|
        if book_key == book_title.to_sym
          current_book = @collection[book_key]
        end
      }
      @users.each_key{ |user_key|
        if user_key == username.to_sym
          current_user = @users[username.to_sym]
        end
      }
    end


    if current_book && current_user && current_book.num_in == 0 && current_book.future_check_out.empty? && current_user.overdue && current_user.max_borrowed
      current_book.borrowed_by.each {|x|
        due_date = x.time_table[current_book.title.to_sym]
      }

      current_book.schedule_future_check_out(@users[username.to_sym], due_date) if current_user && current_book
    end
      
    if !current_book
      puts "No such book exists in our collection."
    elsif current_book.num_in > 0
      puts "You may not schedule a future check because there are copies of the book available now."
    elsif !current_user
      puts "Please register before borrowing any books."
    elsif !current_user.overdue
      puts "You may not schedule a future check out because you have an overdue book."
    elsif !current_user.max_borrowed
      puts "You may not schedule a future check out because you are at your borrowing limit."
    else
      puts "Got it, we will notify you when #{book_title} is ready for you!"
    end
  end
end


Library.add_book("Fish", "Fish Author", "Fish Desc", "Fish Year", "Fish Edition")
Library.add_book("LOTR", "JJ Tokens", "LOTR desc", "LOTR year", "LOTR edition", 4)
Library.add_user("Bob", 4821, "answer")
Library.add_user("Goat", 0000, "answer")
Library.add_user("Jillio", 0000, "answer")
Library.add_user("Goat", 0000, "answer")

Library.check_out("Fish", "Bob", 4821)
Library.return("Fish", "Bob", 4821)

Library.check_out("Fish", "Goat", 0000)

Library.list
Library.info_on("Fish")

Library.check_out("LOTR", "Goat", 0000)
Library.my_books("Goat")

Library.test_over_due("LOTR", "Bob")
Library.check_over_due

Library.write_review("LOTR", 5, "1st Review for LOTR")
Library.write_review("LOTR", 2, "2nd Review for LOTR")

Library.read_review("LOTR")
