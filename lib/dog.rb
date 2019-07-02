class Dog 
  attr_accessor :id, :name, :breed
  
  def initialize(attributes)
    attributes.each {|k, v| self.send(("#{k}="), v)}
    self.id ||= nil
  end
  
  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs 
    SQL
    DB[:conn].execute(sql)
  end 
  
  def save
  if self.id
    self.update
  else
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end
  return self 
end

def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end 

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new_from_db(result)
  end 

  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
<<<<<<< HEAD
      dog = Dog.new_from_db(dog_data)
    else
      dog = self.create(name: name, breed: breed)
=======
      dog = Dog.new(dog_data)
    else
      dog_data = dog[0] 
      dog = self.create(dog_data)
>>>>>>> baca299ac034fceb923e14b07cfcc37711ad7fc4
    end
    dog
  end
  
  def self.new_from_db(row)
    attributes = {
      :id => row[0],
      :name => row[1],
      :breed => row[2]
    }
    self.new(attributes)
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs WHERE name = ?
    SQL
    dog_row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(dog_row)
  end 
  
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
end 