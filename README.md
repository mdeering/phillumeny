# phillumeny

Collection of RSpec matchers for verbose testers.

## Configuration

```ruby
# spec/support/phillumeny.rb
require 'phillumeny'

RSpec.configure do |config|
  config.include Phillumeny::ActiveModel, type: :model
  config.include Phillumeny::FactoryBot,  type: :model
end
```

### ActiveModel

```ruby
RSpec.describe Webpage, type: :model do

  it { should     validate_presence_of_any(:headline, :title).valid_values(title: 'this') }
  it { should_not validate_presence_of_any(:headline, :title) }
  it { should_not validate_presence_of_any(:headline, :title).valid_value(:title, 'that') }

end
```

## Factory Bot

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
