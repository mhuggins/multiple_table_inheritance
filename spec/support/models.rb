#########################################################
# Non-namespaced models with mass-assignment security
# everywhere or only on parent.
#########################################################

class Employee < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :first_name, :last_name, :salary, :team, :team_id
  belongs_to :team
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :salary, :presence => true, :numericality => { :min => 0 }
  
  def give_raise!(amount)
    Employee.update_counters self.id, :salary => amount
  end
end

class Programmer < ActiveRecord::Base
  inherits_from :employee  #, :methods => true
  attr_accessible :languages, :language_ids
  has_many :known_languages
  has_many :languages, :through => :known_languages
end

class Manager < ActiveRecord::Base
  inherits_from :employee  #, :methods => true
  attr_accessible :bonus
  validates :bonus, :numericality => true
end

class Janitor < ActiveRecord::Base
  inherits_from :employee  #, :methods => true
end

class Team < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :employees
  validates :name, :presence => true, :uniqueness => true
end

class Language < ActiveRecord::Base
  attr_accessible :name
  has_many :known_languages
  has_many :programmers, :through => :known_languages
  validates :name, :presence => true, :uniqueness => true
end

class KnownLanguage < ActiveRecord::Base
  belongs_to :programmer
  belongs_to :language
  validates :programmer_id, :presence => true
  validates :language_id, :presence => true, :uniqueness => { :scope => :programmer_id }
end

#########################################################
# Non-namespaced models with mass assignment security
# only on children or not specified.
#########################################################

class Clothing < ActiveRecord::Base
  acts_as_superclass
  validates :color, :presence => true
end

class Shirt < ActiveRecord::Base
  inherits_from :clothing
  attr_accessible :size
  validates :size, :presence => true
end

class Pants < ActiveRecord::Base
  inherits_from :clothing
  validates :waist_size, :presence => true
  validates :length, :presence => true
end

#########################################################
# Namespaced models with mass assignment security
# everywhere or only on parent.
#########################################################

module Pet
  def self.table_name_prefix
    'pet_'
  end
  
  class Owner < ActiveRecord::Base
    attr_accessible :first_name, :last_name
    has_many :pets
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :ssn, :presence => true
  end

  class Pet < ActiveRecord::Base
    acts_as_superclass :subtype => 'species'
    attr_accessible :name
    belongs_to :owner
    validates :owner_id, :presence => true
    validates :name, :presence => true
    
    def rename!(new_name)
      update_attributes!(:name => new_name)
    end
  end
  
  class Cat < ActiveRecord::Base
    inherits_from :pet, :class_name => 'Pet::Pet'
    attr_accessible :longest_nap
  end
  
  class Dog < ActiveRecord::Base
    inherits_from :pet, :class_name => 'Pet::Pet'
  end
end

#########################################################
# Namespaced models with mass assignment security
# only on children or not specified.
#########################################################

module Store
  def self.table_name_prefix
    'store_'
  end
  
  class Furniture < ActiveRecord::Base
    acts_as_superclass
    validates :brand, :presence => true
    validates :name, :presence => true
  end
  
  class Bed < ActiveRecord::Base
    inherits_from :furniture, :class_name => 'Store::Furniture'
    validates :size, :presence => true
  end
  
  class Table < ActiveRecord::Base
    inherits_from :furniture, :class_name => 'Store::Furniture'
    attr_accessible :chairs, :color
    validates :chairs, :presence => true, :numericality => { :min => 1 }
    validates :color, :presence => true
  end
end
