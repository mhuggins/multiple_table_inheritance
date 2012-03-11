require 'multiple_table_inheritance/railtie'

module MultipleTableInheritance
  extend ActiveSupport::Autoload
  
  autoload :Child
  autoload :Parent
  autoload :Migration
end
