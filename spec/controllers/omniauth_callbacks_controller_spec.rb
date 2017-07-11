require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }

  before do
    DatabaseCleaner.clean
    Event.delete_all
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '123456789',
      info: {
        name: 'John Doe',
        email: 'john@company_name.com',
        first_name: 'John',
        last_name: 'Doe',
        image: 'https://lh3.googleusercontent.com/url/photo.jpg'
      }
    )
    allow(User).to receive(:find_for_google_oauth2).and_return(user)
    request.env['devise.mapping'] = Devise.mappings[:user] # If using Devise
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
  end
  context 'will' do
    it 'set user to google user' do
      get :google_oauth2
      expect(user).to eq(user)
    end
    context 'when there is an active event' do
      let(:event) { create(:event) }

      before do
        event.active!
        get :google_oauth2
      end
      after do
        event.archived!
      end
      it 'redirects to join active game if user not signed up' do
        expect(response).to redirect_to(game_join_path(event))
      end

      context 'and the user has previously signed up' do
        let(:event_player) { create(:event_player, player: user, event: event) }

        it 'redirects to the active game' do
          event.active!
          event.reload
          event_player.reload

          get :google_oauth2
          expect(response).to redirect_to(my_game_path(event))
        end
      end
    end
  end
end
