
# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'phillumeny/version'

Gem::Specification.new do |s|
  s.name        = 'phillumeny'
  s.version     = Phillumeny::Version
  s.authors     = ['Michael Deering']
  s.email       = ['mdeering@mdeering.com']
  s.homepage    = 'https://github.com/mdeering/phillumeny'
  s.summary     = 'Collection of RSpec matchers for verbose testers.'

  s.files = Dir['{lib}/**/*']
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'

end
