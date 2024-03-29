class Book
  attr_accessor :title, :author, :rentals
  attr_reader :id

  def initialize(title, author)
    @title = title
    @author = author
    @rentals = []
  end

  def add_rental(rental)
    @rentals.push(rental)
    rental.book = self
  end

  def to_s
    "Title: \"#{@title}\", Author: #{author}"
  end
end
