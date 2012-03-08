# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "multiple_table_inheritance/version"

Gem::Specification.new do |s|
  s.name        = "multiple_table_inheritance"
  s.version     = MultipleTableInheritance::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Huggins"]
  s.email       = ["matt@matthuggins.com"]
  s.homepage    = "http://github.com/mhuggins/multiple_table_inheritance"
  s.summary     = "ActiveRecord plugin designed to allow simple multiple table inheritance."
  s.description = "ActiveRecord plugin designed to allow simple multiple table inheritance."
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.rdoc_options     = ["--charset=UTF-8"]
  s.extra_rdoc_files = ["README.md"]
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = %q{1.3.6}
  
  s.add_dependency('activerecord', '>= 3.0.0')
  s.add_dependency('activesupport', '>= 3.0.0')
  s.add_development_dependency('rspec-rails', '~> 2.8.0')
  s.add_development_dependency('rspec_tag_matchers', '>= 1.0.0')
  s.add_development_dependency('sqlite3-ruby', '>= 1.3.3')
  s.add_development_dependency('database_cleaner', '>= 0.7.1')
  # s.add_development_dependency('appraisal')
end
