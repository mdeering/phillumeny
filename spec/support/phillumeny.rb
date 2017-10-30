# frozen_string_literal: true

require 'phillumeny'

RSpec.configure do |config|
  config.include Phillumeny::FactoryBot, type: :model
end
