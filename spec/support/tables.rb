ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => File.expand_path(File.join(File.dirname(__FILE__), '../../db/multiple_table_inheritance.db'))
)

ActiveRecord::Base.connection do
  ['employees', 'programmers', 'managers', 'teams', 'languages', 'known_languages'].each do |table|
    execute "DROP TABLE IF EXISTS '#{table}'"
  end
  
  create_table :employees do |t|
    t.string :subtype, :null => false
    t.string :first_name, :null => false
    t.string :last_name, :null => false
    t.integer :salary, :null => false 
    t.integer :team_id
  end
  
  create_table :programmers, :inherits => :employee do |t|
  end
  
  create_table :managers, :inherits => :employee do |t|
    t.integer :bonus
  end
  
  create_table :teams do |t|
    t.string :name, :null => false
  end
  
  create_table :languages do |t|
    t.string :name, :null => false
  end
  
  create_table :known_languages do |t|
    t.integer :programmer_id, :null => false
    t.integer :language_id, :null => false
  end
end
