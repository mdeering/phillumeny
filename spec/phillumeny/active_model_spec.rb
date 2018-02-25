# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Webpage, type: :model do

  it { should     validate_presence_of_any(:headline, :title).valid_values(title: 'this') }
  it { should_not validate_presence_of_any(:headline, :title) }
  it { should_not validate_presence_of_any(:headline, :title).valid_value(:title, 'that') }

end
