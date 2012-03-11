###############################################
# Non-namespaced models
###############################################

class Employee < ActiveRecord::Base
  acts_as_superclass
  attr_accessible :first_name, :last_name, :salary, :team, :team_id
  belongs_to :team
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :salary, :presence => true, :numericality => { :min => 0 }
end

class Programmer < ActiveRecord::Base
  inherits_from :employee
  attr_accessible :languages, :language_ids
  has_many :known_languages
  has_many :languages, :through => :known_languages
end

class Manager < ActiveRecord::Base
  inherits_from :employee
  attr_accessible :bonus
  validates :bonus, :numericality => true
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

###############################################
# Namespaced models
###############################################

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
  end
  
  class Cat < ActiveRecord::Base
    inherits_from :pet, :class_name => 'Pet::Pet'
  end
  
  class Dog < ActiveRecord::Base
    inherits_from :pet, :class_name => 'Pet::Pet'
  end
end
