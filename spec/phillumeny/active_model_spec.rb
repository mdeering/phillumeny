# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ActiveModel', type: :model do

  describe Webpage do

    it { should     validate_presence_of_any(:headline, :title).valid_values(title: 'this') }
    it { should_not validate_presence_of_any(:headline, :title) }
    it { should_not validate_presence_of_any(:headline, :title).valid_value(:title, 'that') }

  end

end
