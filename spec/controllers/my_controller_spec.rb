require 'rails_helper'

RSpec.describe MyController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let(:valid_session) { {} }

  describe 'GET #profile' do
    it 'returns http success' do
      sign_in user
      get :profile
      expect(response).to have_http_status(200)
    end
  end
  describe 'PUT #profile_update' do
    context 'with valid params' do
      let(:new_attributes) { user.attributes }

      before do
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

    before do
      sign_in user
    end
    context 'when player has joined game' do
      before do
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

        before do
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
    let!(:event) { create(:event) }
    let!(:event_player) { create(:event_player, player: user, event: event) }
    let!(:event_player_score) { create(:event_player_score, event_player: event_player) }

    before do
      sign_in user
    end

    context 'when the game is `active``' do
      before do
        event.active!
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

    context 'when the game is not `active``' do

      before do
        event.archived!
        get :score,
            params: {
                year: event_player_score.event.year,
                act: event_player_score.participating_country.position,
                event_player_score: event_player_score.attributes
            }
      end

      it 'redirects to the game path' do
        expect(response).to redirect_to(my_game_path)
      end

      it 'returns a 302 code' do
        expect(response.status).to eq(302)
      end

      describe 'a flash alert' do
        it 'is displayed' do
          expect(flash[:alert]).to be_present
        end

        it 'has the correct text' do
          expect(flash[:alert]).to eql('Scoring is locked')
        end
      end
    end

  end
  describe 'PUT #score_create' do
    let(:event_player) { create(:event_player, player: user) }
    let(:event_player_score) { create(:event_player_score, event_player: event_player) }
    let(:prev_fattest_act) { create(:event_player_score, event_player: event_player, fattest: true) }

    before do
      sign_in user
    end
    context 'with valid params' do
      before do
        event_player_score.fattest = true
      end

      it 'updates the score data' do
        expect(prev_fattest_act.fattest).to be true
        post :score_create,
             params: {
               year: event_player_score.event.year,
               act: event_player_score.participating_country.position,
               event_player_score: event_player_score.attributes
             }
        expect(event_player_score.reload.fattest).to be true
        expect(prev_fattest_act.reload.fattest).to be false
      end

      it 'redirects to the game view' do
        post :score_create,
             params: {
               year: event_player_score.event.year,
               act: event_player_score.participating_country.position,
               event_player_score: event_player_score.attributes
             }
        expect(response.status).to be 302
        expect(response).to redirect_to(my_game_path(event_player_score.event))
      end
    end
  end
end
