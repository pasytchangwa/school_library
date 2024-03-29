require 'json'

class Storage
  def load(classroom)
    books = parse_books
    people = parse_people(classroom)
    rentals = parse_rentals(people, books)

    {
      'people' => people,
      'books' => books,
      'rentals' => rentals
    }
  end

  def parse_books
    file = 'books_json'

    if File.exist? file
      JSON.parse(File.read(file), create_additions: true)
    else
      []
    end
  end

  def parse_rentals(people, books)
    file = 'rentals_json'

    if File.exist? file
      JSON.parse(File.read(file)).map do |_rentals_json|
        book = books.find { |current_book| current_book.title == rental_json['book_title'] }
        person = people.find { |current_person| current_person.id == rental_json['person_id'].to_i }

        Rental.new(rental_json['date'], book, person)
      end
    else
      []
    end
  end

  def parse_people(classroom)
    file = 'people_json'

    if File.exist? file
      JSON.parse(File.read(file)).map do |person_json|
        if person_json['json_class'] == 'student'
          creating_student(person_json, classroom)
        else
          creating_teacher person_json
        end
      end
    else
      []
    end
  end

  def creating_student(person_json, classroom)
    id = person_json['id'].to_i
    name = person_json['name']
    age = person_json['age']
    parent_permission = person_json['parent_permission']

    student = Student.new(name: name, age: age, parent_permission: parent_permission, classroom: classroom)
    student.id = id
    student
  end

  def creating_teacher(person_json)
    id = person_json['id'].to_i
    name = person_json['name']
    age = person_json['age']
    specialization = person_json['specialization']

    teacher = Teacher.new(name: name, age: age, specialization: specialization)
    teacher.id = id
    teacher
  end

  def store(people:, rentals:, books:)
    File.open('people.json', 'w') { |f| f.write JSON.generate(people) } unless people.empty?
    File.open('rentals.json', 'w') { |f| f.write JSON.generate(rentals) } unless rentals.empty?
    File.open('books.json', 'w') { |f| f.write JSON.generate(books) } unless books.empty?
  end
end
