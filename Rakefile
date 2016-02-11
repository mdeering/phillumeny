require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:setup, :spec, :rubocop]

desc 'Create the rails application to run our matcher tests wihin/against'
task :setup do
  arguments = []
  arguments << '--force'
  arguments << '--no-rc'
  arguments << '--skip-active-record'
  arguments << '--skip-bundle'
  arguments << '--skip-gemfile'
  arguments << '--skip-spring'
  arguments << '--skip-test-unit'
  arguments << '--skip-turbo-links'
  arguments << '--template=./spec/support/rails/rspec.template'
  puts `rails new tmp/dummy #{arguments.join(' ')}`
end
