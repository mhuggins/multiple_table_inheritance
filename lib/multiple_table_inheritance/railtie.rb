module MultipleTableInheritance
  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      initializer 'multiple_table_inheritance.insert_into_active_record' do
        ::ActiveSupport.on_load(:active_record) { Railtie.insert }
      end
    end
  end
  
  class Railtie
    def self.insert
      ::ActiveRecord::Base.module_eval do
        include MultipleTableInheritance::Child::Base
        include MultipleTableInheritance::Parent::Base
      end
      
      ::ActiveRecord::Relation.module_eval do
        include MultipleTableInheritance::Parent::Relation
      end
      
      ::ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
        include MultipleTableInheritance::Migration
      end
    end
  end
end
