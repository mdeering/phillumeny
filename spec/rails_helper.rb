require 'spec_helper'

require File.expand_path('../../tmp/dummy/config/environment', __FILE__)

require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
end
