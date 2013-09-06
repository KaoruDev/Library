class User
  # User class will hold information on each user, such as:
  #
  # - Name
  # - Pin number (four-digit password) to verify actions
  # - Array of borrowed books.
  # - Overdue books
  # - Time borrowed, time due.

  attr_reader :first_name, :last_name

  pin_num # kept local so others can't acces it.

  def initialize(first_name, last_name, pin_num)
    # Records first and last name and pin number user sets.
    @first_name = first_name
    @last_name = last_name
    @pin_num = pin_num
  end

end