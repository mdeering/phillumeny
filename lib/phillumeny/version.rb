# frozen_string_literal: true

module Phillumeny

  # Nothing to special to see here. Doing my best to follow semantic versioning that conform
  # with Rubygems/bundler dependency determinations
  module Version

    MAJOR      = 0
    MINOR      = 2
    PATCH      = 0
    PRERELEASE = nil
    # PRERELEASE = 'alpha'.freeze

    def self.to_s
      [MAJOR, MINOR, PATCH, PRERELEASE].compact.join('.')
    end

  end

end
