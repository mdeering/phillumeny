require 'rails_helper'

RSpec.describe 'post administration routing' do

  it { should route_resources(:comments).namespace(:admin).all_actions.member('approve' => 'put', spam: :put) }

end
