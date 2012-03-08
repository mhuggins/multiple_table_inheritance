require 'spec_helper'

describe MultipleTableInheritance::ActiveRecord::Parent do
  context 'retrieving records' do
    it 'should only fetch child records' do
      Employee.find_each do |employee|
        employee.should_not be_instance_of(Employee)
        ['Programmer', 'Manager'].should include(employee.class.to_s)
      end
    end
    
    it 'should fetch all child records' do
      pending "find_without_inheritance is not working as intended"
      modified_results = Employee.all
      original_results = Employee.find_without_inheritance { Employee.all }
      modified_results.size.should == original_results.size
    end
    
    it 'should maintain result order' do
      pending "find_without_inheritance is not working as intended"
      modified_results = Employee.order("id desc").all
      original_results = Employee.find_without_inheritance { Employee.order("id desc").all }
      modified_results.collect(&:id).should == original_results.collect(&:id)
    end
    
    context 'an invalid subtype exists' do
      before do
        @employee = Employee.create!(:first_name => 'Sub', :last_name => 'Type', :salary => 50000, :team => @team) do |employee|
          employee.subtype = 'DoesNotExist'
        end
      end
      
      it 'should return successfully' do
        @employee.should be_instance_of(Employee)
      end
      
      it 'should log an error' do
        pending "logger.error should have been called"
      end
    end
    
    context 'default subtype used' do
      pending "test_everything"
    end
    
    context 'custom subtype used' do
      pending "test_everything"
    end
    
    context 'namespaced classes are being used' do
      pending "test_everything"
    end
  end
  
  context 'deleting records' do
    before do
      programmer = Programmer.create!(:first_name => 'Billy', :last_name => 'Ray', :salary => 50000, :team => @team)
      @employee = programmer.employee
      @employee_id = programmer.id
    end
    
    it 'should delete the parent record' do
      @employee.destroy.should be_true
      Employee.find_by_id(@employee_id).should be_nil
    end
    
    it 'should delete the child record' do
      @employee.destroy.should be_true
      Programmer.find_by_id(@employee_id).should be_nil
    end
  end
end
