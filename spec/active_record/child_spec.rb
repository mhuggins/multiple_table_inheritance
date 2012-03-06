require 'spec_helper'

describe MultipleTableInheritance::ActiveRecord::Child do
  context 'retrieving records' do
    it 'should only fetch subtypes' do
      subtypes = Employee.all.collect(&:subtype).uniq
      subtypes.each do |subtype|
        ['Programmer', 'Manager'].should include(subtype)
      end
    end
    
    it 'should fetch all child records' do
      pending "find_by_sql_without_inherit.size.should == find_by_sql_with_inherit.size"
    end
    
    context 'an invalid subtype is included' do
      it 'should return successfully' do
        pending "error should not be thrown"
      end
      
      it 'should generate log entry' do
        pending "logger.error should have been called"
      end
    end
    
    it 'should maintain result order' do
      pending "find_by_sql_without_inherit.collect(&:id).should == find_by_sql_with_inherit.collect(&:id)"
    end
    
    context 'default subtype used' do
      pending "test_everything"
    end
    
    context 'custom subtype used' do
      pending "test_everything"
    end
    
    it 'should work with namespaced classes' do
      pending "test_everything"
    end
    
    it 'should inherit parent methods' do
      pending 'todo'
    end
  end
  
  context 'creating records' do
    pending "todo"
  end
  
  context 'updating records' do
    pending "todo"
  end
  
  context 'deleting records' do
    pending "todo"
  end
end
