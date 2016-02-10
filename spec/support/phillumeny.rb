require 'phillumeny/factory_girl'
require 'phillumeny/rails'

RSpec.configure do |config|
  config.include Phillumeny::FactoryGirl, type: :model
  config.include Phillumeny::Rails::Matchers::RoutingMatchers, type: :routing
end
