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
        include MultipleTableInheritance::ActiveRecord::Child
        include MultipleTableInheritance::ActiveRecord::Parent
      end
      
      ::ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
        include MultipleTableInheritance::ActiveRecord::Migration
      end
    end
  end
end
