# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'phillumeny/version'

Gem::Specification.new do |s|
  s.name        = 'phillumeny'
  s.version     = Phillumeny::Version
  s.authors     = ['Michael Deering']
  s.email       = ['mdeering@mdeering.com']
  s.homepage    = 'https://github.com/mdeering/phillumeny'
  s.summary     = %q{Collection of RSpec matchers for verbose testers.}
  s.description = %q{A supplement of missing matchers for the shoulda collection for those who really like to test everything including the framework.}

  s.files = Dir['{lib}/**/*']
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'

end
