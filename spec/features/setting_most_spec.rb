require 'rails_helper'

feature 'user scoring' do
  include Warden::Test::Helpers
  Warden.test_mode!
  let(:user) { create(:user) }
  let(:event) { create(:event, :with_countries) }
  let(:player) { create(:event_player, event: event, player: user) }
  let(:eps_1) { EventPlayerScore.find_by(event_player: player, participating_country: event.participating_countries.first) }
  let(:eps_2) { EventPlayerScore.find_by(event_player: player, participating_country: event.participating_countries.second) }

  before do
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
    eps_1.update_attributes(score: 5, wackiest: true)
  end

  scenario 'sets a performance to wackiest' do
    visit root_path
    click_link :login
    expect(page).to have_xpath("//div[contains(., 'Successfully authenticated from Google account')] ")
    expect(page).to have_xpath("//input[@type='text' and @value='1/3 acts']")
    click_link 'score_act_2'
    check 'event_player_score_wackiest'
    choose 'event_player_score_score_7', visible: false
    click_button 'Submit score'
    eps_1.reload
    eps_2.reload
    expect(eps_2.wackiest).to be true
    expect(eps_1.wackiest).to be false
  end
end
