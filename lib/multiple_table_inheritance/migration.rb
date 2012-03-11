module MultipleTableInheritance
  module Migration
    def self.included(base)
      base.alias_method_chain :create_table, :inherits
    end
    
    def create_table_with_inherits(table_name, options = {}, &block)
      options[:primary_key] = "#{options[:inherits]}_id" if options[:inherits]
      create_table_without_inherits(table_name, options, &block)
    end
  end
end
