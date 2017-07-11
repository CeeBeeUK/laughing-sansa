require 'rails_helper'

RSpec.describe EventsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/events').to route_to('events#index')
    end

    it 'routes to #new' do
      expect(get: '/events/new').to route_to('events#new')
    end

    it 'routes to #show' do
      expect(get: '/events/2015').to route_to('events#show', year: '2015')
    end

    it 'routes to #edit' do
      expect(get: '/events/2015/edit').to route_to('events#edit', year: '2015')
    end

    it 'routes to #create' do
      expect(post: '/events').to route_to('events#create')
    end

    it 'routes to #update' do
      expect(put: '/events/2015').to route_to('events#update', year: '2015')
    end

    it 'routes to #destroy' do
      expect(delete: '/events/2015').to route_to('events#destroy', year: '2015')
    end
    it 'routes to #join' do
      expect(get: '/events/2015/join').to route_to('events#join', year: '2015')
    end
    it 'routes to #sign_up' do
      expect(post: '/events/2015/join').to route_to('events#sign_up', year: '2015')
    end

    it 'has a admin page' do
      expect(get: '/events/2016/admin').to route_to('events#admin', year: '2016')
    end
  end
end
