db_path = File.expand_path(File.join(File.dirname(__FILE__), '../../db'))
db_file = File.join(db_path, 'multiple_table_inheritance.db')

# Create/Overwrite database file
File.delete(db_file) if File.exist?(db_file)
Dir.mkdir(db_path) unless File.directory?(db_path)
File.open(db_file, 'w') {}

# Open a database connection
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => db_file)
