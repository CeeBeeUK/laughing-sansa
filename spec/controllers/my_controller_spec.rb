require 'rails_helper'

RSpec.describe MyController, type: :controller do

  include Devise::Test::ControllerHelpers
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
      let(:new_attributes) { user.attributes }
      before(:each) do
        sign_in user
        new_attributes['display_name'] = 'test display'
      end
      it 'updates the requested event' do
        put :profile_update, params: { id: user.to_param, user: new_attributes }, session: valid_session
        user.reload
        expect(user.display_name).to eql('test display')
      end

      it 'assigns the requested user as @user' do
        put :profile_update, params: { id: user.to_param, user: new_attributes }, session: valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        put :profile_update, params: { id: user.to_param, user: new_attributes }, session: valid_session
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
        event_player = create(:event_player, player: user, event: event)
        get :game, params: { year: event_player.event.to_param }
      end
      it 'returns success code' do
        expect(response.status).to eq(200)
      end
      it 'renders the game template' do
        expect(response).to render_template(:game)
      end
    end
    context 'when player has not joined game' do

      it 'redirects' do
        get :game, params: { year: event.to_param }
        expect(response.status).to eq(302)
      end
      context 'when the game can be joined' do
        it 'renders the event page' do
          event.active!
          get :game, params: { year: event.to_param }
          expect(response).to redirect_to game_sign_up_path(event)
        end
      end
      context 'when the game cannot be joined' do
        let(:event_player) { create(:event_player, player: user) }
        let(:event_player_score) { create(:event_player_score, event_player: event_player) }

        before(:each) do
          get :game, params: { year: event.to_param }
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
  describe 'GET #{game}score' do
    let(:event_player) { create(:event_player, player: user) }
    let(:event_player_score) { create(:event_player_score, event_player: event_player) }

    before(:each) do
      sign_in user
      get :score,
        params: {
          year: event_player_score.event.year,
          act: event_player_score.participating_country.position,
          event_player_score: event_player_score.attributes
        }
    end
    it 'renders the score page' do
      expect(response).to render_template(:score)
    end
    it 'returns a 200 code' do
      expect(response.status).to eq(200)
    end
  end
  describe 'PUT #score_create' do
    let(:event_player) { create(:event_player, player: user) }
    let(:event_player_score) { create(:event_player_score, event_player: event_player) }
    before(:each) do
      sign_in user
    end
    context 'with valid params' do
      before(:each) do
        event_player_score.fattest = true
        post :score_create,
          params: {
            year: event_player_score.event.year,
            act: event_player_score.participating_country.position,
            event_player_score: event_player_score.attributes
          }
      end
      it 'updates the score data' do
        event_player_score.reload
        expect(event_player_score.fattest).to eql(true)
      end
      it 'returns a redirect code' do
        expect(response.status).to eql(302)
      end
      it 'redirects to the game view' do
        expect(response).to redirect_to(my_game_path(event_player_score.event))
      end
    end
  end
end
