require 'rails_helper'

RSpec.describe MyController, type: :routing do
  describe 'routing' do
    it 'routes to #profile' do
      expect(get: 'my/profile').to route_to('my#profile')
    end
    it 'routes to #update on patch' do
      expect(patch: 'my/profile').to route_to('my#profile_update')
    end
    it 'routes to #game' do
      expect(get: 'my/2015/game').to route_to('my#game', year: '2015')
    end
  end
end
