require 'rails_helper'

RSpec.describe MyController, type: :routing do
  describe 'routes' do
    it '#profile' do
      expect(get: 'my/profile').to route_to('my#profile')
    end
    it 'to #update on patch' do
      expect(patch: 'my/profile').to route_to('my#profile_update')
    end
    it '#game' do
      expect(get: 'my/2015/game').to route_to('my#game', year: '2015')
    end
    it '#score' do
      expect(get: 'my/2015/score/act/1').to route_to('my#score', year: '2015', act: '1')
    end
  end
end
