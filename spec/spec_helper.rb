require 'active_record'
require 'database_cleaner'
require 'multiple_table_inheritance'

MultipleTableInheritance::ActiveRecord::Parent::ClassMethods.module_eval do
  def find_without_inheritance(&block)
    # remove_method :find_by_sql
    extend ActiveRecord::Querying
    result = yield
    extend MultipleTableInheritance::ActiveRecord::Parent::FinderMethods
    result
  end
end

MultipleTableInheritance::Railtie.insert

require 'support/tables'
require 'support/models'

module MultipleTableInheritanceSpecHelper
  def mock_everything
    @team = Team.create!(:name => 'Website')
    @java = Language.create!(:name => 'Java')
    @cpp = Language.create!(:name => 'C++')
    @programmer = Programmer.create!(
        :first_name => 'Mario',
        :last_name => 'Mario',
        :salary => 65000,
        :team => @team,
        :languages => [@java, @cpp])  # programmer-specific relationship
    @manager = Manager.create!(
        :first_name => 'King',
        :last_name => 'Koopa',
        :salary => 70000,
        :team => @team,
        :bonus => 5000)  # manager-specific field
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
    mock_everything
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
