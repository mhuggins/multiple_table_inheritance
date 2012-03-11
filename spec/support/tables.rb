ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.join(File.dirname(__FILE__), '../../db/multiple_table_inheritance.db'))
)

conn = ActiveRecord::Base.connection

TABLES = ['employees', 'programmers', 'managers', 'teams', 'languages', 'known_languages', 'pet_owners', 'pet_pets', 'pet_dogs', 'pet_cats'].freeze
TABLES.each do |table|
  conn.execute "DROP TABLE IF EXISTS '#{table}'"
end

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
