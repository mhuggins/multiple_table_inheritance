require 'spec_helper'

describe MultipleTableInheritance::Child do
  context 'retrieving records' do
    before do
      programmer = Programmer.create!(:first_name => 'Bob', :last_name => 'Smith', :salary => 50000)
      @programmer_id = programmer.id
      @programmer = Programmer.find(@programmer_id)
    end
    
    it 'should retrieve child records' do
      @programmer.should be_instance_of(Programmer)
      @programmer.id.should be(@programmer_id)
    end
    
    it 'should allow access to parent record' do
      @programmer.employee.should be_instance_of(Employee)
      @programmer.employee.id.should be(@programmer_id)
    end
  end
  
  context 'creating records' do
    context 'with mass assignment security' do
      context 'specifying fields that are accessible' do
        it 'should assign accessible fields' do
          pending "create a model that allows for proper testing"
        end
        
        it 'should save child associations' do
          pending "create a model that allows for proper testing"
        end
        
        it 'should save parent associations' do
          pending "create a model that allows for proper testing"
        end
      end
      
      context 'specifying fields that are not accessible' do
        it 'should not assign secure fields' do
          pending "create a model that allows for proper testing"
        end
        
        it 'should not save child associations' do
          pending "create a model that allows for proper testing"
        end
        
        it 'should not save parent associations' do
          pending "create a model that allows for proper testing"
        end
      end
    end
  end
  
  context 'updating records' do
    pending "todo"
  end
  
  context 'deleting records' do
    before do
      mock_employees!
      @programmer = Programmer.first
      @programmer_id = @programmer.id
    end
    
    it 'should delete the parent record' do
      @programmer.destroy
      Employee.find_by_id(@programmer_id).should be_nil
    end
    
    it 'should delete the child record' do
      @programmer.destroy.should be_true
      Programmer.find_by_id(@programmer_id).should be_nil
    end
  end
  
  context 'when instructed to inherit parent methods' do
    it 'should inherit parent methods' do
      pending "todo"
    end
  end
  
  context 'methods' do
    before do
      mock_employees!
    end
    
    context 'accessing parent records' do
      before do
        @programmer = Programmer.create!(:first_name => 'Bob', :last_name => 'Smith', :salary => 50000)
      end
      
      it 'should allow access to parent records' do
        employee = @programmer.employee
        employee.should be_instance_of(Employee)
        employee.id.should be(@programmer.id)
      end
    end
    
    context 'searching by id' do
      context 'at the class level' do
        before do
          @employee_id = Employee.first.id
          @employee = Employee.find_by_id(@employee_id)
        end
        
        it 'should return a valid record' do
          @employee.should be_instance_of(@employee.subtype.constantize)
          @employee.id.should be(@employee_id)
        end
      end
      
      context 'at the instance level' do
        before do
          team = Team.first
          @employee_id = team.employees.first.id
          @employee = team.employees.find_by_id(@employee_id)
        end
        
        it 'should return a valid record' do
          @employee.should be_instance_of(@employee.subtype.constantize)
          @employee.id.should be(@employee_id)
        end
      end
    end
  end
end
