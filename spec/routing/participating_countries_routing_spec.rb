require 'rails_helper'

RSpec.describe ParticipatingCountriesController, type: :routing do
  describe 'routing' do

    it 'routes to #manage' do
      expect(get: '/events/2014/countries').to route_to('participating_countries#manage', year: '2014')
    end
    it 'routes to #sort' do
      expect(post: '/participating_countries/2014/sort').to route_to('participating_countries#sort', year: '2014')
    end
    it 'routes to #create' do
      expect(post: 'participating_countries/2014/create').to route_to('participating_countries#create', year: '2014')
    end
    it 'routes to #allocate' do
      expect(put: '/participating_countries/2014/allocate').to route_to('participating_countries#allocate', year: '2014')
    end
  end
end
