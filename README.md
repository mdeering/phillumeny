# Phillumeny

## A collection of RSpec matchers for verbose testers.

---

## ActiveModel matchers

```ruby
# spec/models/user_spec.rb
require 'spec_helper'

RSpec.describe User, type: :model do

  context 'Factories' do

    it { should have_a_valid_factory }

    it { should_not have_a_valid_factory.with_trait(:something_wrong) }

  end
end
```

## Configuration

```ruby
# spec/support/phillumeny.rb
require 'phillumeny/factorygirl'
require 'phillumeny/rails'

RSpec.configure do |config|
  config.include Phillumeny::FactoryGirl, type: :model
  config.include Phillumeny::Rails::Matchers::Routing, type: :routing
end
```
