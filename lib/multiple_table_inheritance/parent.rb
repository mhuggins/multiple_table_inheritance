module MultipleTableInheritance
  module Parent
    extend ActiveSupport::Autoload
    
    autoload :Base
    autoload :Relation
  end
end
