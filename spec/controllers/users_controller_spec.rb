require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }

  context 'as a guest' do
    before do
      get :index
    end
    it 'returns a redirect status' do
      expect(response).to have_http_status(:redirect)
    end
    it 'redirect to event page' do
      expect(response).to redirect_to(root_path)
    end
  end
  context 'as a user' do
    before do
      sign_in user
      get :index
    end
    it 'returns a redirect status' do
      expect(response).to have_http_status(:redirect)
    end
    it 'redirect to event page' do
      expect(response).to redirect_to(root_path)
    end
  end
  context 'as an admin' do
    before do
      sign_in admin
      get :index
    end
    it 'returns a success status' do
      expect(response).to have_http_status(:success)
    end
    it 'renders the template' do
      expect(response).to render_template :index
    end
  end
end
