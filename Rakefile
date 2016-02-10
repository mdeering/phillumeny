require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: [:spec, :rubocop]

# rails new tmp/dummy --skip-bundle --skip-active-record --skip-spring --skip-gemfile --skip-test-unit --skip-turbo-links --no-rc
