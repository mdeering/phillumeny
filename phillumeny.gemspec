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

  s.rubyforge_project = 'phillumeny'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'

end
