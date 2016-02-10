require 'rails_helper'

RSpec.describe 'post administration routing' do

  it { should restfully_route(:posts).namespace(:admin).except(:show) }

end
