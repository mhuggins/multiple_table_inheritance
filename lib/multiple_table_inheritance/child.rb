module MultipleTableInheritance
  module Child
    extend ActiveSupport::Autoload
    
    autoload :Base
    autoload :Sanitizer
  end
end
