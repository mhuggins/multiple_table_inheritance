module MultipleTableInheritance
  module ActiveRecord
    module Parent
      def self.default_options
        { :subtype => 'subtype' }
      end
      
      def self.included(base)
        base.extend(ClassMethods)
        base.class_attribute :subtype_column
      end
      
      module ClassMethods
        def acts_as_superclass(options={})
          options = Parent::default_options.merge(options.to_options.reject { |k,v| v.nil? })
          self.subtype_column = options[:subtype]
          
          if self.column_names.include?(subtype_column.to_s)
            class << self
              alias_method_chain :find_by_sql, :inherits
            end
          end
        end
        
        private
        
        def find_by_sql_with_inherits(*args)
          parent_records = find_by_sql_without_inherits(*args)
          child_records = []
          
          # find all child records
          ids_by_type(parent_records).each do |type, ids|
            begin
              klass = type.constantize
              child_records += klass.find(ids)
            rescue NameError => e
              # TODO log error
            end
          end
          
          # associate the parent records with the child records to reduce SQL calls and prevent recursion
          child_records.each do |child|
            association_name = to_s.demodulize.underscore
            parent = parent_records.find { |parent| child.id == parent.id }
            child.send("#{association_name}=", parent)
          end
          
          # TODO order the child_records array to match the order of the parent_records array (by comparing id's)
          
          child_records
        end
        
        def ids_by_type(records)
          subtypes = records.collect(&self.subtype_column.to_sym).uniq
          subtypes = subtypes.collect do |subtype|
            subtype_records = records.select { |record| record[subtype_column.to_sym] == subtype}
            subtype_ids = subtype_records.collect { |record| record.id }
            [subtype, subtype_ids]
          end
          Hash[subtypes]
        end
      end
    end
  end
end
