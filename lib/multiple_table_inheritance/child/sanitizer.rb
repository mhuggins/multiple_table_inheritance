require 'activemodel/mass_assignment_security/sanitizer' unless defined?(ActiveModel::MassAssignmentSecurity::LoggerSanitizer)

module MultipleTableInheritance
  module Child
    class Sanitizer < ActiveModel::MassAssignmentSecurity::LoggerSanitizer
      def initialize(target)
        @target = target
        super
      end
      
      def sanitize(attributes, authorizer)
        sanitized_attributes = attributes.reject { |key, value| deny?(key) }
        debug_protected_attribute_removal(attributes, sanitized_attributes)
        sanitized_attributes
      end
      
    protected
      
      def deny?(key)
        return true if protected_attribute?(key)
        return !accessible_attribute?(key)
      end
      
      def protected_attribute?(key)
        protected_attributes.include?(key)
      end
      
      def accessible_attribute?(key)
        return true if accessible_parent_attributes.empty? && parent_attribute_names.include?(key)
        return true if accessible_child_attributes.empty? && child_attribute_names.include?(key)
        accessible_attributes.include?(key)
      end
      
      def protected_attributes
        @protected_attributes ||= (@target.protected_attributes + @target.parent_association_class.protected_attributes)
      end
      
      def accessible_attributes
        @accessible_attributes ||= (@target.accessible_attributes + @target.parent_association_class.accessible_attributes)
      end
      
      def accessible_child_attributes
        @accessible_child_attributes ||= @target.accessible_attributes
      end
      
      def accessible_parent_attributes
        @accessible_parent_attributes ||= @target.parent_association_class.accessible_attributes
      end
      
      def child_attribute_names
        @child_attribute_names ||= @target.attribute_names
      end
      
      def parent_attribute_names
        @parent_attribute_names ||= @target.parent_association_class.attribute_names
      end
    end
  end
end
