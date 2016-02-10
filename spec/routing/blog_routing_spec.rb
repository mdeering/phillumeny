require 'rails_helper'

RSpec.describe 'blog routing' do

  it { should restfully_route('/blog').controller(:posts).only(:show).param(:slug) }

end
