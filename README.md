Multiple Table Inheritance
==========================

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

    gem install multiple-table-inheritance

From your Gemfile:

    gem 'multiple_table_inheritance', '~> 0.1.0'

Usage
=====

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

When creating tables that are derived from your superclass table, simple
provide the `:inherits` hash option to your `create_table` call.

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

    class ::Employee < ActiveRecord::Base
      acts_as_superclass
      validates :first_name, :presence => true
      validates :last_name, :presence => true
      validates :salary, :presence => true, :numericality => { :min => 0 }
    end
    
    class ::Programmer < ActiveRecord::Base
      inherits_from :employee
    end
    
    class ::Manager < ActiveRecord::Base
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

**NOTE:** When an ActiveRecord model does not make a call to `attr_accessible`,
all its fields are presumed to be accessible.  Currently, when using
MultipleTableInheritance, if a parent class does not call `attr_accesible` and
one of its children does, then the parent's attributes cannot properly be
stored.  This will be fixed in a future release.

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
    
    class ::Programmer < ActiveRecord::Base
      inherits_from :employee
      has_many :known_languages
      has_many :languages, :through => :known_languages
    end
    
    class ::Language < ActiveRecord::Base
      attr_accessible :name
      has_many :known_languages
      has_many :programmers, :through => :known_languages
    end
    
    class ::KnownLanguage < ActiveRecord::Base
      belongs_to :programmer
      belongs_to :language
    end
    
    programmer = Programmer.first           # <Programmer employee_id: 1 training_completed_at: "2009-03-06 00:30:00">
    programmer.languages.collect(&:name)    # ['Java', 'C++']
    programmer.team.name                    # 'Website Front-End'
