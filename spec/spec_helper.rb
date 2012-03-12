require 'active_record'
require 'database_cleaner'
require 'multiple_table_inheritance'

MultipleTableInheritance::Railtie.insert

require 'support/tables'
require 'support/models'

module MultipleTableInheritanceSpecHelper
  def mock_employees!
    3.times do |i|
      team = Team.create!(:name => "Team #{i}")
      language = Language.create!(:name => "Java 1.#{i + 4}")
    end
    
    3.times do |i|
      Programmer.create!(
          :first_name => "Joe",
          :last_name => "Schmoe #{i}",
          :salary => 60000 + (i * 5000),
          :team => Team.first,
          :languages => Language.limit(2))  # programmer-specific relationship
      
      Manager.create!(
          :first_name => "Bob",
          :last_name => "Smith #{i}",
          :salary => 70000 + (i * 2500),
          :team => Team.first,
          :bonus => i * 2500)  # manager-specific field
      
      Janitor.create!(
          :first_name => "Phil",
          :last_name => "Moore #{i}",
          :salary => 40000 + (i * 1000),
          :team => Team.last,
          :preferred_cleaner => %w{Comet Windex Swiffer}[i])  # janitor-specific field
    end
  end
  
  def mock_pets!
    3.times do |i|
      owner = Pet::Owner.create!(:first_name => 'Bob', :last_name => "Smith #{i}") do |owner|
        owner.ssn = (123456789 + i).to_s
      end
      
      dog = Pet::Dog.create!(:name => "Rover #{i}") do |dog|
        dog.owner = owner
        dog.favorite_toy = "#{i + 1}-inch Bone"  # dog-specific field
      end
      
      cat = Pet::Cat.create!(:name => "Mittens #{i}") do |cat|
        cat.owner = owner
        cat.longest_nap = 100 + i  # cat-specific field
      end
    end
  end
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  include MultipleTableInheritanceSpecHelper
  
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
