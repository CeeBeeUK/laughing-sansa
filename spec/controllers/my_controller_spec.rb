require 'rails_helper'

RSpec.describe MyController, type: :controller do

  include Devise::TestHelpers
  let(:user) { create(:user) }
  let(:valid_session) { {} }

  describe 'GET #profile' do
    it 'returns http success' do
      sign_in user
      get :profile
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #profile_update' do
    context 'with valid params' do
      let(:new_attributes) { user.attributes  }
      before(:each) do
        sign_in user
        new_attributes['display_name'] = 'test display'
      end
      it 'updates the requested event' do
        put :profile_update, { id: user.to_param, user: new_attributes }, valid_session
        user.reload
        expect(user.display_name).to eql('test display')
      end

      it 'assigns the requested user as @user' do
        put :profile_update, { id: user.to_param, user: new_attributes }, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        put :profile_update, { id: user.to_param, user: new_attributes }, valid_session
        expect(response).to redirect_to(my_profile_path)
      end
    end
  end

  describe 'GET #game' do

    let(:event) { create(:event) }

    before(:each) do
      sign_in user
    end
    context 'when player has joined game' do
      before(:each) do
        participating_player = create(:participating_player, player: user, event: event)
        get :game, year: participating_player.event.to_param
      end
      it 'returns success code' do
        expect(response.status).to eq(200)
      end
      it 'renders the game template' do
        expect(response).to render_template(:game)
      end
    end
    context 'when player has not joined game' do
      before(:each) do
        get :game, year: event.to_param
      end
      it 'redirects' do
        expect(response.status).to eq(302)
      end
      it 'renders root' do
        expect(response).to redirect_to(root_path)
      end
      it 'displays a flash message' do
        expect(flash[:alert]).to be_present
      end
    end
  end
end
