require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routes' do
    it '#index' do
      expect(get: 'users').to route_to('users#index')
    end
  end
end
