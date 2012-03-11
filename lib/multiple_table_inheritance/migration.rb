module MultipleTableInheritance
  module Migration
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def create_table(table_name, options = {}, &block)
        options[:primary_key] = "#{options[:inherits]}_id" if options[:inherits]
        super(table_name, options, &block)
      end
    end
  end
end
