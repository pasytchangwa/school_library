class Rental
  attr_accessor :date, :person, :book

  def initialize(date, person, book)
    @date = date

    @person = person
    person.rentals << self

    @book = book
    book.rentals << self
  end

  def to_s
    "Date: #{@date}, Book: \"#{book.title}\" by #{book.author}"
  end
end
