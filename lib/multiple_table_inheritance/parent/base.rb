module MultipleTableInheritance
  module Parent
    module Base
      def self.included(base)
        base.extend ClassMethods
        base.class_attribute :subtype_column
      end
      
      def self.default_options
        { :subtype => 'subtype' }
      end
      
      module ClassMethods
        delegate :as_supertype, :to => :scoped
        
        def acts_as_superclass(options={})
          options = Base::default_options.merge(options.to_options)
          self.subtype_column = options[:subtype]
          
          if column_names.include?(subtype_column.to_s)
            include InstanceMethods
            before_destroy :destroy_child_association
          end
        end
      end
      
      module InstanceMethods
        def destroy_child_association
          child_class = send(subtype_column.to_sym).constantize
          if child = child_class.find_by_id(id)
            child.delete
          end
        rescue NameError => e
          logger.warn "Can't find matching child association for deletion: #{self.class} ##{id}" if logger
        end
        
        def find_by_subtype(*args)
          super || send("find_by_#{subtype_column}", *args)
        end
      end
    end
  end
end
