require 'rspec-rails'

module Phillumeny
  module Rails
    module Matchers
      module RoutingMatchers
        extend RSpec::Matchers::DSL

        def restfully_route(*expected)
          RestfullyRouteMatcher.new(self, *expected)
        end

        class RestfullyRouteMatcher < RSpec::Matchers::BuiltIn::BaseMatcher
        end

      end
    end
  end
end
