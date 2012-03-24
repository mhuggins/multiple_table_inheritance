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

conn.create_table :janitors, :inherits => :employee do |t|
  t.string :preferred_cleaner
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

#########################################################
# Store entities
#########################################################

conn.create_table :store_furnitures do |t|
  t.string :subtype, :null => false
  t.string :brand, :null => false
  t.string :name, :null => false
end

conn.create_table :store_beds, :inherits => :furniture do |t|
  t.string :size, :null => false
end

conn.create_table :store_tables, :inherits => :furniture do |t|
  t.integer :chairs, :null => false
  t.string :color, :null => false
end

#########################################################
# Store entities
#########################################################

conn.create_table :users do |t|
  t.string :username, :null => false
end

conn.create_table :images do |t|
  t.string :url, :null => false
end

conn.create_table :advertisements do |t|
  t.string :subtype, :null => false
  t.integer :user_id, :null => false
end

conn.create_table :image_advertisements, :inherits => :advertisement do |t|
  t.integer :image_id, :null => false
end

conn.create_table :text_advertisements, :inherits => :advertisement do |t|
  t.string :title, :null => false
  t.string :body, :null => false
end
