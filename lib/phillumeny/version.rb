# frozen_string_literal: true

module Phillumeny

  # Nothing to special to see here. Doing my best to follow semantic versioning that conform
  # with Rubygems/bundler dependency determinations
  module Version

    MAJOR      = 0
    MINOR      = 0
    PATCH      = 1
    PRERELEASE = nil
    # PRERELEASE = 'alpha'.freeze
    BUILD      = 0

    def self.to_s
      [MAJOR, MINOR, PATCH, PRERELEASE, BUILD].compact.join('.')
    end

  end

end
