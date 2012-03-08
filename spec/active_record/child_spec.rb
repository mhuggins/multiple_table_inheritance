require 'spec_helper'

describe MultipleTableInheritance::ActiveRecord::Child do
  context 'retrieving records' do
    pending "todo"
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
  
  context 'when instructed to inherit parent methods' do
    it 'should inherit parent methods' do
      pending "todo"
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
