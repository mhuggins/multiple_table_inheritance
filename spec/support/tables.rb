db_path = File.expand_path(File.join(File.dirname(__FILE__), '../../db'))
db_file = File.join(db_path, 'multiple_table_inheritance.db')

# Create/Overwrite database file
File.delete(db_file) if File.exist?(db_file)
Dir.mkdir(db_path) unless File.directory?(db_path)
File.open(db_file, 'w') {}

# Open a database connection
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => db_file)
conn = ActiveRecord::Base.connection

#########################################################
# Employee entities
#########################################################

conn.create_table :employees do |t|
  t.string :subtype, :null => false
  t.string :first_name, :null => false
  t.string :last_name, :null => false
  t.integer :salary, :null => false 
  t.integer :team_id
end

conn.create_table :programmers, :inherits => :employee do |t|
end

conn.create_table :managers, :inherits => :employee do |t|
  t.integer :bonus
end

conn.create_table :teams do |t|
  t.string :name, :null => false
end

conn.create_table :languages do |t|
  t.string :name, :null => false
end

conn.create_table :known_languages do |t|
  t.integer :programmer_id, :null => false
  t.integer :language_id, :null => false
end

#########################################################
# Clothing entities
#########################################################

conn.create_table :clothings do |t|
  t.string :subtype, :null => false
  t.string :color, :null => false
end

conn.create_table :shirts, :inherits => :clothing do |t|
  t.string :size, :limit => 2, :null => false
end

conn.create_table :pants, :inherits => :clothing do |t|
  t.integer :waist_size, :null => false
  t.integer :length, :null => false
end

#########################################################
# Pet entities
#########################################################

conn.create_table :pet_owners do |t|
  t.string :first_name, :null => false
  t.string :last_name, :null => false
  t.string :ssn, :null => false
end

conn.create_table :pet_pets do |t|
  t.string :species, :null => false
  t.integer :owner_id, :null => false
  t.string :name, :null => false
  t.string :color
end

conn.create_table :pet_dogs, :inherits => :pet do |t|
  t.string :favorite_toy
end

conn.create_table :pet_cats, :inherits => :pet do |t|
  t.integer :longest_nap
end
