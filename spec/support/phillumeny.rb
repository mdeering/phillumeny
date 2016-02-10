require 'phillumeny'

RSpec.configure do |config|
  config.include Phillumeny::FactoryGirl, type: :model
  config.include Phillumeny::Rails::Matchers::RoutingMatchers, type: :routing
end
