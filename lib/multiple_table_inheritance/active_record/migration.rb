module MultipleTableInheritance
  module ActiveRecord
    module Migration
      def self.included(base)
        base.class_eval do
          alias_method_chain :create_table, :inherits
        end
      end
      
      # Generate the association field.
      def create_table_with_inherits(table_name, options = {}, &block)
        options[:primary_key] = "#{options[:inherits]}_id" if options[:inherits]
        
        create_table_without_inherits(table_name, options) do |table_defintion|
          yield table_defintion   
        end  
      end
    end
  end
end
