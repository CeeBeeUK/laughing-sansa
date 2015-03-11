require 'rails_helper'

RSpec.describe 'Events', type: :request do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }

  describe 'GET /events' do
    it 'redirects when user not authenticated' do
      get events_path
      expect(response.status).to eql(302)
    end

    it 'returns 200 when authenticated' do
      login_as(user, scope: user)
      get events_path
      expect(response.status).to eql(200)
    end

    it 'returns 200 when authorised' do
      login_as(admin_user, scope: user)
      get events_path
      expect(response.status).to eql(200)
    end
  end
  describe 'GET /events/new' do
    it 'redirects when not authenticated' do
      get new_event_path
      expect(response.status).to eql(302)
    end
    context 'valid user' do

      let(:countries) {
        assign(:countries,
          [
            Country.create(name: 'country 1'),
            Country.create(name: 'country 2')
          ]
        )
      }

      it 'returns 200 when authenticated' do
        login_as(user, scope: user)
        get new_event_path
        expect(response.status).to eql(302)
      end

      it 'returns 200 when authorised' do
        login_as(admin_user, scope: user)
        get new_event_path
        expect(response.status).to eql(200)
      end
    end
  end
end
