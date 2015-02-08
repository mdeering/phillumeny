module Phillumeny

  module Version

    MAJOR      = 0
    MINOR      = 1
    PATCH      = 0
    PRERELEASE = 'alpha'
    BUILD      = 0

    def self.to_s
      [MAJOR, MINOR, PATCH, PRERELEASE, BUILD].compact.join('.')
    end

  end

end
