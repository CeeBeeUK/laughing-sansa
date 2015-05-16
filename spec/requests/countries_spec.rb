require 'rails_helper'

RSpec.describe 'Countries', type: :request do

  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    Event.delete_all
    Country.delete_all
  end

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:country) { create(:country, name: 'Albania') }

  describe 'GET /countries' do
    it 'redirects when not authenticated.' do
      get countries_path
      expect(response.status).to eql(302)
    end

    it 'redirects when not authorised.' do
      login_as(user, scope: :user)
      get countries_path
      expect(response.status).to eql(302)
    end

    it 'returns status code 200 when authenticated.' do
      login_as(admin_user, scope: :user)
      get countries_path
      expect(response.status).to eql(200)
    end
  end
end
