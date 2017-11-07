require 'rails_helper'

feature 'user scoring' do
  scenario 'sets a performance to fattest' do
    event = create(:event)
    player = create(:event_player, event: event)

    visit root_path
    click_link :login
    expect(page).to have_content('event')
  end
end