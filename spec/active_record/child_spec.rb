require 'spec_helper'

describe MultipleTableInheritance::Child do
  context 'non-namespaced classes with default subtype' do
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
        context 'on just child' do
          context 'without assigning all attributes' do
            before(:each) do
              @shirt = Shirt.create(:color => 'Red')
            end
            
            it 'should have errors' do
              @shirt.errors.messages.should_not be_empty
              @shirt.errors.messages.keys.should include(:size)
            end
            
            it 'should not have been saved' do
              @shirt.should be_new_record
            end
          end
          
          context 'with all attributes assigned' do
            before(:each) do
              @shirt = Shirt.create(:color => 'Red', :size => 'XL')
            end
            
            it 'should not have errors' do
              @shirt.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @shirt.should_not be_new_record
            end
          end
        end
        
        context 'on just parent' do
          context 'without assigning all attributes' do
            before(:each) do
              @janitor = Janitor.create(:first_name => 'Billy', :last_name => 'McGee')
            end
            
            it 'should have errors' do
              @janitor.errors.messages.should_not be_empty
              @janitor.errors.messages.keys.should include(:salary)
            end
            
            it 'should not have been saved' do
              @janitor.should be_new_record
            end
          end
          
          context 'with all attributes assigned' do
            before(:each) do
              @janitor = Janitor.create(:first_name => 'Billy', :last_name => 'McGee', :salary => 40000, :favorite_cleaner => 'Swiffer')
            end
            
            it 'should not have errors' do
              @janitor.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @janitor.should_not be_new_record
            end
          end
        end
        
        context 'on child and parent' do
          context 'with attributes set on instance' do
            before(:each) do
              @programmer = Programmer.create(:first_name => 'Joe', :last_name => 'Schmoe') do |programmer|
                programmer.team = Team.first
                programmer.salary = 45000
              end
            end
            
            it 'should not have errors' do
              @programmer.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @programmer.should_not be_new_record
            end
          end
          
          context 'with attributes specified in hash' do
            before(:each) do
              @programmer = Programmer.create(:first_name => 'Joe', :last_name => 'Schmoe', :salary => 45000)
            end
            
            it 'should not have errors' do
              @programmer.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @programmer.should_not be_new_record
            end
          end
        end
      end
      
      context 'without mass assignment security' do
        context 'without assigning all attributes' do
          before(:each) do
            @pants = Pants.create(:color => 'Blue', :waist_size => 32)
          end
          
          it 'should have errors' do
            @pants.errors.messages.should_not be_empty
            @pants.errors.messages.keys.should include(:length)
          end
          
          it 'should not have been saved' do
            @pants.should be_new_record
          end
        end
        
        context 'with all attributes assigned' do
          before(:each) do
            @pants = Pants.create(:color => 'Blue', :waist_size => 32, :length => 34)
          end
          
          it 'should not have errors' do
            @pants.errors.messages.should be_empty
          end
          
          it 'should have been saved' do
            @pants.should_not be_new_record
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
  end
  
  context 'namespaced classes with custom subtype' do
    context 'retrieving records' do
      before do
        mock_pets!
        @dog = Pet::Dog.first
        @dog_id = @dog.id
      end
      
      it 'should retrieve child records' do
        @dog.should be_instance_of(Pet::Dog)
        @dog.id.should be(@dog_id)
      end
      
      it 'should allow access to parent record' do
        @dog.pet.should be_instance_of(Pet::Pet)
        @dog.pet.id.should be(@dog_id)
      end
    end
    
    context 'creating records' do
      before(:each) do
        @owner = Pet::Owner.create!(:first_name => 'Bob', :last_name => 'Smith') { |owner| owner.ssn = '123456789' }
      end
      
      context 'with mass assignment security' do
        context 'on just child' do
          context 'without assigning all attributes' do
            before(:each) do
              @table = Store::Table.create(:brand => 'Rio', :name => 'Corner Office')
            end
            
            it 'should have errors' do
              @table.errors.messages.should_not be_empty
              @table.errors.messages.keys.should include(:color)
              @table.errors.messages.keys.should include(:chairs)
            end
            
            it 'should not have been saved' do
              @table.should be_new_record
            end
          end
          
          context 'with all attributes assigned' do
            before(:each) do
              @table = Store::Table.create(:brand => 'Rio', :name => 'Corner Office', :color => 'Brown', :chairs => 1)
            end
            
            it 'should not have errors' do
              @table.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @table.should_not be_new_record
            end
          end
        end
        
        context 'on just parent' do
          context 'with attributes set on instance' do
            before(:each) do
              @dog = Pet::Dog.create(:name => 'Fido') do |dog|
                dog.owner = @owner
                dog.color = 'black'
                dog.favorite_toy = 'Squeeky Ball'
              end
            end
            
            it 'should not have errors' do
              @dog.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @dog.should_not be_new_record
            end
          end
          
          context 'with attributes specified in hash' do
            before(:each) do
              owner = Pet::Owner.create!(:first_name => 'Bob', :last_name => 'Smith') { |owner| owner.ssn = '123456789' }
              @dog = Pet::Dog.create(:name => 'Fido', :color => 'black', :owner => @owner, :favorite_toy => 'Squeeky Ball')
            end
            
            it 'should assign accessible fields' do
              @dog.name.should be_present
            end
            
            it 'should not assign secure fields' do
              @dog.color.should_not be_present
              @dog.owner.should_not be_present
              @dog.owner_id.should_not be_present
              @dog.favorite_toy.should_not be_present
            end
            
            it 'should have errors' do
              @dog.errors.messages.should_not be_empty
            end
            
            it 'should not have been saved' do
              @dog.should be_new_record
            end
          end
        end
        
        context 'on child and parent' do
          context 'with attributes set on instance' do
            before(:each) do
              @cat = Pet::Cat.create(:name => 'Mittens', :longest_nap => 100) do |cat|
                cat.owner = @owner
                cat.color = 'orange'
              end
            end
            
            it 'should not have errors' do
              @cat.errors.messages.should be_empty
            end
            
            it 'should have been saved' do
              @cat.should_not be_new_record
            end
          end
          
          context 'with attributes specified in hash' do
            before(:each) do
              @cat = Pet::Cat.create(:name => 'Fido', :color => 'black', :owner => @owner, :longest_nap => 50)
            end
            
            it 'should assign accessible fields' do
              @cat.name.should be_present
              @cat.longest_nap.should be_present
            end
            
            it 'should not assign secure fields' do
              @cat.color.should_not be_present
              @cat.owner.should_not be_present
              @cat.owner_id.should_not be_present
            end
            
            it 'should have errors' do
              @cat.errors.messages.should_not be_empty
            end
            
            it 'should not have been saved' do
              @cat.should be_new_record
            end
          end
        end
      end
      
      context 'without mass assignment security' do
        context 'without assigning all attributes' do
          before(:each) do
            @bed = Store::Bed.create(:brand => 'Sealy', :size => 'Queen')
          end
          
          it 'should have errors' do
            @bed.errors.messages.should_not be_empty
            @bed.errors.messages.keys.should include(:name)
          end
          
          it 'should not have been saved' do
            @bed.should be_new_record
          end
        end
        
        context 'with all attributes assigned' do
          before(:each) do
            @bed = Store::Bed.create(:brand => 'Sealy', :name => 'Feathertop', :size => 'Queen')
          end
          
          it 'should not have errors' do
            @bed.errors.messages.should be_empty
          end
          
          it 'should have been saved' do
            @bed.should_not be_new_record
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
  end
  
  context 'methods' do
    context 'accessing parent methods' do
      context 'on models that allow methods to be inherited' do
        before do
          mock_employees!
          @programmer = Programmer.first
        end
        
        it 'should allow parent methods to be called through child' do
          pending "infinite recursion must be addressed"
          # @programmer.should respond_to(:give_raise!)
        end
      end
      
      context 'on models that do not allow methods to be inherited' do
        before do
          mock_pets!
          @cat = Pet::Cat.first
        end
        
        it 'should not allow parent methods to be called through child' do
          @cat.should_not respond_to(:rename!)
        end
      end
    end
    
    context 'accessing parent records' do
      before do
        @salary = 50000
        @programmer = Programmer.create!(:first_name => 'Bob', :last_name => 'Smith', :salary => @salary)
      end
      
      it 'should allow access to parent attribute methods' do
        @programmer.salary.should == @salary
      end
      
      it 'should allow access to parent records' do
        employee = @programmer.employee
        employee.should be_instance_of(Employee)
        employee.id.should be(@programmer.id)
      end
    end
    
    context 'searching by id' do
      before do
        mock_employees!
      end
      
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
