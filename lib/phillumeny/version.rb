module Phillumeny

  # Nothing to special to see here. Doing my best to follow semantic versioning that conform
  # with Rubygems/bundler dependency determinations
  module Version

    MAJOR      = 0
    MINOR      = 1
    PATCH      = 0
    PRERELEASE = 'alpha'.freeze
    BUILD      = 0

    def self.to_s
      [MAJOR, MINOR, PATCH, PRERELEASE, BUILD].compact.join('.')
    end

  end

end
