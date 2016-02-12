require 'rails_helper'

RSpec.describe 'blog routing' do

  it { should route_resources(:posts).only('show').param(:slug).path('/blog') }
  it { should route_resources(:posts).only(:show).param(:slug).path('/blog') }
  it { should_not route_resources(:posts).except(:show).param(:slug).path('/blog') }
  it { should_not route_resources(:posts).except(:show).param(:slug).path('/blog') }

end
