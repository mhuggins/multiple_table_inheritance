require 'spec_helper'

describe MultipleTableInheritance::Parent do
  describe 'methods' do
    it 'should allow records to be found without inheritance' do
      employees = Employee.as_supertype.all
      employees.each do |employee|
        employee.should be_instance_of(Employee)
      end
    end
  end
  
  context 'retrieving records' do
    before do
      mock_everything!
    end
    
    it 'should retrieve child records' do
      Employee.find_each do |programmer_or_manager|
        programmer_or_manager.should_not be_instance_of(Employee)
        ['Programmer', 'Manager'].should include(programmer_or_manager.class.to_s)
      end
    end
    
    it 'should allow access to parent record' do
      programmer_or_manager = Employee.first
      programmer_or_manager.employee.should be_instance_of(Employee)
    end
    
    it 'should include all records' do
      modified_results = Employee.all
      original_results = Employee.as_supertype.all
      modified_results.size.should == original_results.size
    end
    
    it 'should maintain result order' do
      modified_results = Employee.order("id desc").all
      original_results = Employee.as_supertype.order("id desc").all
      modified_results.collect(&:id).should == original_results.collect(&:id)
    end
    
    context 'associations preloading' do
      context 'is enabled' do
        before do
          @programmer_or_manager = Employee.includes(:team).first
        end
        
        it 'should not perform an extra find' do
          pending "ensure that team is not retrieved from the database"
          Team.any_instance.should_not_receive(:find_by_sql)
          @programmer_or_manager.employee.team
        end
      end
      
      context 'is disabled' do
        before do
          @programmer_or_manager = Employee.first
        end
        
        it 'should not perform an extra find' do
          pending "ensure that team is retrieved from the database"
          Team.any_instance.should_receive(:find_by_sql).at_least(:once)
          @programmer_or_manager.employee.team
        end
      end
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
    
    context 'default subtype is used' do
      pending "test_everything"
    end
    
    context 'custom subtype is used' do
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
      @employee.destroy
      Programmer.find_by_id(@employee_id).should be_nil
    end
  end
end
