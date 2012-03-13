module MultipleTableInheritance
  module Parent
    module Relation
      def self.included(base)
        base.class_eval do
          attr_accessor :return_supertype
          alias_method_chain :to_a, :inherits
        end
      end
      
      def to_a_with_inherits
        parent_records = to_a_without_inherits
        return parent_records if @return_supertype || !@klass.subtype_column
        
        # Find all child records.
        child_records = []
        ids_by_type(parent_records).each do |type, ids|
          begin
            klass = type.constantize
            child_records += klass.find(ids)
          rescue NameError => e
            logger.warn "Can't find matching child association for deletion: #{type} #{ids.inspect}" if logger
          end
        end
        
        # Associate the parent records with the child records to reduce SQL calls and prevent recursion.
        child_records.each do |child|
          association_name = @klass.to_s.demodulize.underscore
          parent = parent_records.find { |parent| child.id == parent.id }
          child.send("#{association_name}=", parent)
        end
        
        # Order the child_records array to match the order of the parent_records array.
        child_records.sort! do |a, b|
          a_index = parent_records.index { |parent| parent.id == a.id }
          b_index = parent_records.index { |parent| parent.id == b.id }
          a_index <=> b_index
        end
      end
      
      def as_supertype
        relation = clone
        relation.return_supertype = true
        relation
      end
      
      private
      
      def ids_by_type(records)
        subtypes = records.collect(&@klass.subtype_column.to_sym).uniq
        subtypes = subtypes.collect do |subtype|
          subtype_records = records.select { |record| record[@klass.subtype_column.to_sym] == subtype}
          subtype_ids = subtype_records.collect { |record| record.id }
          [subtype, subtype_ids]
        end
        Hash[subtypes]
      end
    end
  end
end
