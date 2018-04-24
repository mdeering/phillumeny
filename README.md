
![](phillumeny-logo.png)

Collection of RSpec matchers for verbose testers.

## Configuration

```ruby
# spec/support/phillumeny.rb
require 'phillumeny'

# require 'phillumeny/active_record'

RSpec.configure do |config|
  config.include Phillumeny::ActiveModel,  type: :model
  config.include Phillumeny::ActiveRecord, type: :model
  config.include Phillumeny::FactoryBot,   type: :model
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

### ActiveRecord

```ruby
RSpec.describe Post, type: :model do

  [[:include_in_sitemap, :published_at], :published_at].each do |columns|
    it { should cover_query_with_indexes(columns) }
  end

  {
    include_in_sitemap:       true,
    sitemap_change_frequency: 'monthly',
    sitemap_priorty:          5,
    title:                    nil
  }.each do |attribute, value|
    it { should have_default_value_of(value).for(attribute).in_the_database }
  end

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
