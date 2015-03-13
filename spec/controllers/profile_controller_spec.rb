require 'rails_helper'

RSpec.describe ProfileController, type: :controller do

  include Devise::TestHelpers
  let(:user) { create(:user) }
  let(:valid_session) { {} }

  describe 'GET #show' do
    it 'returns http success' do
      sign_in user
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { user.attributes  }
      before(:each) do
        sign_in user
        new_attributes['display_name'] = 'test display'
      end
      it 'updates the requested event' do
        put :update, { id: user.to_param, user: new_attributes }, valid_session
        user.reload
        expect(user.display_name).to eql('test display')
      end

      it 'assigns the requested user as @user' do
        put :update, { id: user.to_param, user: new_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        put :update, { id: user.to_param, user: new_attributes }, valid_session
        expect(response).to redirect_to(my_profile_path)
      end
    end
  end
end
