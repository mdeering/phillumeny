require 'rails_helper'

RSpec.describe 'blog routing' do

  it { should route_resources(:posts).only(:show).param(:slug).path('/slug') }

end
