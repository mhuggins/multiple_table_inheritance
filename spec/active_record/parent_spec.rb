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
  
  context 'non-namespaced classes with default subtype' do
    context 'retrieving records' do
      before do
        mock_employees!
      end
      
      it 'should retrieve child records' do
        Employee.find_each do |employee_subtype|
          employee_subtype.should_not be_instance_of(Employee)
          ['Programmer', 'Manager', 'Janitor'].should include(employee_subtype.class.to_s)
        end
      end
      
      it 'should allow access to parent record' do
        employee_subtype = Employee.first
        employee_subtype.employee.should be_instance_of(Employee)
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
            @employee_subtype = Employee.includes(:team).first
          end
          
          it 'should not perform an extra find' do
            Team.should_not_receive(:find_by_sql)
            @employee_subtype.employee.team
          end
        end
        
        context 'is disabled' do
          before do
            @employee_subtype = Employee.first
          end
          
          it 'should not perform an extra find' do
            pending "appears to be an rspec bug preventing this from working"
            Team.should_not_receive(:find_by_sql).with(any_args).once
            @employee_subtype.employee.team
          end
        end
      end
    end
    
    context 'deleting records' do
      before do
        programmer = Programmer.create!(:first_name => 'Billy', :last_name => 'Ray', :salary => 50000)
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
    
    context 'an invalid subtype exists' do
      before do
        @employee = Employee.create!(:first_name => 'Sub', :last_name => 'Type', :salary => 50000) do |employee|
          employee.subtype = 'DoesNotExist'
        end
      end
      
      it 'should not have errors' do
        @employee.errors.messages.should be_empty
      end
      
      it 'should have been saved' do
        @employee.should_not be_new_record
      end
      
      context 'retrieving saved record' do
        before do
          @record = Employee.find_by_id(@employee.id)
        end
        
        it 'should not return the parent model instance' do
          @record.should be_nil
        end
        
        context 'logger exists on model' do
          before do
            require 'logger'
            @logger = Logger.new(nil)
            ActiveRecord::Base.stub(:logger).and_return(@logger)
          end
          
          it 'should log a warning' do
            @logger.should_receive(:warn)
            Employee.find_by_id(@employee.id)
          end
        end
      end
    end
  end
  
  context 'namespaced classes with custom subtype' do
    context 'retrieving records' do
      before(:each) do
        mock_pets!
      end
      
      it 'should retrieve child records' do
        Pet::Pet.find_each do |cat_or_dog|
          cat_or_dog.should_not be_instance_of(Pet::Pet)
          ['Pet::Cat', 'Pet::Dog'].should include(cat_or_dog.class.to_s)
        end
      end
      
      it 'should allow access to parent record' do
        cat_or_dog = Pet::Pet.first
        cat_or_dog.pet.should be_instance_of(Pet::Pet)
      end
      
      it 'should include all records' do
        modified_results = Pet::Pet.all
        original_results = Pet::Pet.as_supertype.all
        modified_results.size.should == original_results.size
      end
      
      it 'should maintain result order' do
        modified_results = Pet::Pet.order("id desc").all
        original_results = Pet::Pet.as_supertype.order("id desc").all
        modified_results.collect(&:id).should == original_results.collect(&:id)
      end
    end
    
    context 'deleting records' do
      before do
        mock_pets!
        dog = Pet::Dog.first
        @pet = dog.pet
        @pet_id = dog.id
      end
      
      it 'should delete the parent record' do
        @pet.destroy.should be_true
        Pet::Pet.find_by_id(@pet_id).should be_nil
      end
      
      it 'should delete the child record' do
        @pet.destroy
        Pet::Dog.find_by_id(@pet_id).should be_nil
      end
    end
  end
end
