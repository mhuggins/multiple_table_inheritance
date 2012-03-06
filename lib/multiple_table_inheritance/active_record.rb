module MultipleTableInheritance
  module ActiveRecord
    extend ActiveSupport::Autoload
    
    autoload :Child
    autoload :Parent
    autoload :Migration
  end
end
