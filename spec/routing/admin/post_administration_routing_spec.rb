require 'rails_helper'

RSpec.describe 'post administration routing' do

  it { should route_resources(:posts).namespace(:admin).except('show') }
  pending { should route_resources(:posts).namespace(:admin).except(:show) }

end
