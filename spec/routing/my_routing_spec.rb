require 'rails_helper'

RSpec.describe MyController, type: :routing do
  describe 'routing' do
    it 'routes to #profile' do
      expect(get: 'my/profile').to route_to('my#profile')
    end
    it 'routes to #update on patch' do
      expect(patch: 'my/profile').to route_to('my#profile_update')
    end
  end
end
