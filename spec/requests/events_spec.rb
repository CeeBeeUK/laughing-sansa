require 'rails_helper'

RSpec.describe 'Events', type: :request do

  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    Event.delete_all
    Country.delete_all
  end

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:event) { create(:event, country: create(:country, name: 'Albania')) }

  describe 'GET /events' do
    it 'redirects when user not authenticated' do
      get events_path
      expect(response.status).to eql(302)
    end

    it 'returns 200 when authenticated' do
      login_as user
      get events_path
      expect(response.status).to eql(200)
    end

    it 'returns 200 when authorised' do
      login_as(admin_user, scope: :user)
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

      let(:countries) do
        assign(:countries,
          [
            Country.create(name: 'country 1'),
            Country.create(name: 'country 2')
          ])
      end

      it 'returns 302 when authenticated' do
        login_as(user, scope: :user)
        get new_event_path
        expect(response.status).to eql(302)
      end

      it 'returns 200 when authorised' do
        login_as admin_user
        get new_event_path
        expect(response.status).to eql(200)
      end
    end
  end
end
