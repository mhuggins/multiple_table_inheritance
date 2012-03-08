require 'spec_helper'

describe MultipleTableInheritanceSpecHelper do
  it 'should allow records to be found without inheritance' do
    pending "find_without_inheritance is not working as intended"
    employees = Employee.find_without_inheritance { Employee.all }
    employees.each do |employee|
      employee.should be_instance_of(Employee)
    end
  end
end
