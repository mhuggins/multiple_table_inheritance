Multiple Table Inheritance
==========================

[![Build Status](https://secure.travis-ci.org/mhuggins/multiple_table_inheritance.png)](http://travis-ci.org/mhuggins/multiple_table_inheritance)

Multiple Table Inheritance is a plugin designed to allow for multiple table
inheritance between your database tables and your ActiveRecord models.

This plugin is a derivative of the original class-table-inheritance gem, which
can be found at http://github.com/brunofrank/class-table-inheritance


Compatibility
=============

Multiple Table Inheritance is Rails 3.x compatible.


How to Install
==============

From the command line:

    gem install multiple_table_inheritance

From your Gemfile:

    gem 'multiple_table_inheritance', '~> 0.1.6'

Usage
=====

The following sections attempt to explain full coverage for the Multiple Table
Inheritance plugin.  For full code examples, take a look at the test database
structure and associated models found in `spec/support/tables.rb` and
`spec/support/models.rb`, respectively.

Running Migrations
------------------

When creating your tables, the table representing the superclass must include a
`subtype` string column.  (Optionally, you can provide a custom name for this
field and provide the custom name in your model options.)  It is recommended
that this column be non-null for sanity.

    create_table :employees do |t|
      t.string :subtype, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.integer :salary, :null => false
      t.timestamps
    end

When creating tables that are derived from your superclass table, simply
provide the `:inherits` hash option to your `create_table` call.  The value of
the option represent the name by which the association is referenced in your
model.

    create_table :programmers, :inherits => :employee do |t|
      t.datetime :training_completed_at
    end
    
    create_table :managers, :inherits => :employee do |t|
      t.integer :bonus, :null => false
    end

Creating Models
---------------

The `acts_as_superclass` method is used to represent that a model can be
extended.

    class Employee < ActiveRecord::Base
      acts_as_superclass
    end

As mentioned in the migration section, the name of the subtype column can be
defined here if it's something other than the default of "subtype".

    class Employee < ActiveRecord::Base
      acts_as_superclass, :subtype => 'employee_type'
    end

Conversely, the `inherits_from` method is used to represent that a given model
extends another model.  It takes one optional parameter, which is the symbol
desired for referencing the relationship.

    class Programmer < ActiveRecord::Base
      inherits_from :employee
    end
    
    class Manager < ActiveRecord::Base
      inherits_from :employee
    end

Additional options can be passed to represent the exact relationship structure.
Specifically, any option that can be provided to `belongs_to` can be provided
to `inherits_from`.  (Presently, this has only be tested to work with the
`:class_name` option.)

    class Resources::Manager < ActiveRecord::Base
      inherits_from :employee, :class_name => 'Resources::Employee'
    end

Creating Records
----------------

Records can be created directly from their inheriting (child) model classes.
Given model names `Employee`, `Programmer`, and `Manager` based upon the table
structures outlined in the "Running Migrations" section, records can be created
in the following manner.

    Programmer.create(
        :first_name => 'Bob',
        :last_name => 'Smith',
        :salary => 65000,
        :training_completed_at => 3.years.ago)

    Manager.create(
        :first_name => 'Joe'
        :last_name => 'Schmoe',
        :salary => 75000,
        :bonus => 5000)

Retrieving Records
------------------

Records can be retrieved explicitly by their own type.

    programmer = Programmer.first  # <Programmer employee_id: 1 training_completed_at: "2009-03-06 00:30:00">
    programmer.id                  # 1
    programmer.first_name          # "Bob"
    programmer.last_name           # "Smith"
    programmer.salary              # 65000

Records can be retrieved implicitly by the superclass type.

    employees = Employee.limit(2)  # [<Programmer employee_id: 1 training_completed_at: "2009-03-06 00:30:00">,
                                      <Manager employee_id: 2 bonus: 5000>]
    employees.first.class          # Programmer
    employees.last.class           # Manager
    employees.first.bonus          # undefined method `bonus`
    employees.last.bonus           # 5000

Deleting Records
----------------

Records can be deleted by either the parent or child reference.

    Manager.first.destroy          # destroys associated Employee reference as well
    Employee.first.destroy         # destroys associated Manager reference as well

Validation
----------

When creating a new record that inherits from another model, validation is
taken into consideration across both models.

    class Employee < ActiveRecord::Base
      acts_as_superclass
      validates :first_name, :presence => true
      validates :last_name, :presence => true
      validates :salary, :presence => true, :numericality => { :min => 0 }
    end
    
    class Programmer < ActiveRecord::Base
      inherits_from :employee
    end
    
    class Manager < ActiveRecord::Base
      inherits_from :employee
      validates :bonus, :presence => true, :numericality => true
    end
    
    Programmer.create(:first_name => 'Bob', :last_name => 'Jones', :salary => -50)
    # fails because :salary must be >= 0
    
    Manager.create!(:first_name => 'Bob', :last_name => 'Jones', :salary => 75000)
    # fails because :bonus is not present

Mass Assignment Security
------------------------

Mass assignment security can optionally be used in the same manner you would
for a normal ActiveRecord model.

    class Employee < ActiveRecord::Base
      acts_as_superclass
      attr_accessible :first_name, :last_name, :salary
    end
    
    class Manager < ActiveRecord::Base
      inherits_from :employee
      attr_accessible :bonus
    end

Associations
------------

Associations will also work in the same way as other attributes.

    class Team < ActiveRecord::Base
      attr_accessible :name
    end
    
    class Employee < ActiveRecord::Base
      acts_as_superclass
      belongs_to :team
    end
    
    class Programmer < ActiveRecord::Base
      inherits_from :employee
      has_many :known_languages
      has_many :languages, :through => :known_languages
    end
    
    class Language < ActiveRecord::Base
      attr_accessible :name
      has_many :known_languages
      has_many :programmers, :through => :known_languages
    end
    
    class KnownLanguage < ActiveRecord::Base
      belongs_to :programmer
      belongs_to :language
    end
    
    programmer = Programmer.first           # <Programmer employee_id: 1 training_completed_at: "2009-03-06 00:30:00">
    programmer.languages.collect(&:name)    # ['Java', 'C++']
    programmer.team.name                    # 'Website Front-End'

Methods
-------

When inheriting from another parent model, methods can optionally be called on
the parent model automatically as well.  To do so, specify the `:methods`
option when calling `inherits_from`.

    class Employee < ActiveRecord::Base
      acts_as_superclass
      belongs_to :team
      
      def give_raise!(amount)
        update_attribute!(:salary, self.salary + amount)
        puts "Congrats on your well-deserved raise, #{self.first_name}!"
      end
    end
    
    class Programmer < ActiveRecord::Base
      inherits_from :employee, :methods => true
    end
    
    @programmer = Programmer.first
    @programmer.give_raise!
    # yields: "Congrats on your well-deserved raise, Mike!"

NOTE: This is not fully implemented yet as of version 0.1.6.  Please wait until
a future release to prior to using this feature.
