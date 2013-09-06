class User
  # User class will hold information on each user, such as:
  #
  # - Username
  # - Pin number (four-digit password) to verify actions
  # - Answer to security question.
  # - List of borrowed books.
  # - Overdue books
  # - Book status

  attr_reader :username

  pin_num # kept local so others can't acces it.

  def initialize(username, pin_num, answer)
    # Records first and last name and pin number user sets.
    @username = username
    @pin_num = pin_num
  end

end