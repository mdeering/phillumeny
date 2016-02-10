require 'rails_helper'

RSpec.describe 'post administration routing' do

  it { should route_resources(:posts).namespace(:admin).except('show') }
  it { should route_resources(:posts).namespace(:admin).except(:show) }
  it { should_not route_resources(:posts).namespace(:admin).only('show') }
  it { should_not route_resources(:posts).namespace(:admin).only(:show) }

end
