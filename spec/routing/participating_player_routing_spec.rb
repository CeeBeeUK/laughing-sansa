require 'rails_helper'

RSpec.describe ParticipatingPlayerController, :type => :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/events/2015/join').to route_to('participating_player#new', year: '2015')
    end
    it 'routes to #create' do
      expect(post: '/events/2015/join').to route_to('participating_player#create', year: '2015')
    end
  end
end