# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'FactoryGirl', type: :model do

  describe User do

    it { should have_a_valid_factory }

  end

  describe Namespace::User do

    it { should_not have_a_valid_factory }
    it { should have_a_valid_factory.with_trait(:valid) }

  end

end
