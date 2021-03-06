require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
     SELECT * FROM students
    SQL
    all_students_array = DB[:conn].execute(sql)

    all_students_array.map do |student_row|
      Student.new_from_db(student_row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
     SELECT * FROM students WHERE students.name = ?
    SQL
    student_found = DB[:conn].execute(sql, name)[0]
    Student.new_from_db(student_found)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9

    self.all.select do |student|
      student.grade == "9"
    end
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade.to_i < 12
    end
  end

  def self.first_X_students_in_grade_10(num)
    self.all.select do |student|
      student.grade == "10"
    end[0...num]
  end

  def self.first_student_in_grade_10
    self.all.select do |student|
        student.grade == "10"
    end[0]

  end

  def self.all_students_in_grade_X(grade_x)
    self.all.select do |student|
      student.grade == grade_x.to_s
    end
  end


end
