module MultipleTableInheritance
  module Child
    class Sanitizer
      def initialize(target, role)
        @target = target
        @role = role
        super
      end
      
      def sanitize(attributes)
        sanitized_attributes = attributes.reject { |key, value| deny?(key) }
        debug_protected_attribute_removal(attributes, sanitized_attributes)
        sanitized_attributes
      end
      
    protected
      
      def debug_protected_attribute_removal(attributes, sanitized_attributes)
        removed_keys = attributes.keys - sanitized_attributes.keys
        process_removed_attributes(removed_keys) if removed_keys.any?
      end
      
    private
      
      def logger
        @target.logger
      end
      
      def logger?
        @target.respond_to?(:logger) && @target.logger
      end
      
      def process_removed_attributes(attrs)
        logger.warn "Can't mass-assign protected attributes: #{attrs.join(', ')}" if logger?
      end
      
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
        @protected_attributes ||= (protected_child_attributes + protected_parent_attributes)
      end
      
      def accessible_attributes
        @accessible_attributes ||= (accessible_child_attributes + accessible_parent_attributes)
      end
      
      def protected_child_attributes
        @protected_child_attributes ||= @target.protected_attributes(@role)
      end
      
      def protected_parent_attributes
        @protected_parent_attributes ||= @target.parent_association_class.protected_attributes(@role)
      end
      
      def accessible_child_attributes
        @accessible_child_attributes ||= @target.accessible_attributes(@role)
      end
      
      def accessible_parent_attributes
        @accessible_parent_attributes ||= @target.parent_association_class.accessible_attributes(@role)
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
