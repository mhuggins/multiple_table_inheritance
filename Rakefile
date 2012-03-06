require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

desc 'Default: run unit specs.'
task :default => :spec

# require 'rake'
# require 'rake/testtask'
# require 'rake/rdoctask'
# 
# desc 'Default: run unit tests.'
# task :default => :test
# 
# desc 'Test the multiple_table_inheritance plugin.'
# Rake::TestTask.new(:test) do |t|
#   t.libs << 'lib'
#   t.libs << 'test'
#   t.pattern = 'test/**/*_test.rb'
#   t.verbose = true
# end
# 
# desc 'Generate documentation for the multiple_table_inheritance plugin.'
# Rake::RDocTask.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'MultipleTableInheritance'
#   rdoc.options << '--line-numbers' << '--inline-source'
#   rdoc.rdoc_files.include('README')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end
# 
# begin
#   require 'jeweler'
#   Jeweler::Tasks.new do |gem|
#     gem.name = "multiple_table_inheritance"
#     gem.summary = "ActiveRecord plugin designed to allow simple multiple table inheritance."
#     gem.description = "ActiveRecord plugin designed to allow simple multiple table inheritance."
#     gem.email = "tvdeyen@gmail.com"
#     gem.homepage = "http://github.com/tvdeyen/multiple_table_inheritance"
#     gem.authors = `git log --pretty=format:"%an"`.split("\n").uniq.sort
#     gem.add_dependency "activerecord", ">=3.0.0"
#   end
#   Jeweler::GemcutterTasks.new
# rescue LoadError
#   puts "Jeweler (or a dependency) not available."
#   puts "Install it with: gem install jeweler"
# end
