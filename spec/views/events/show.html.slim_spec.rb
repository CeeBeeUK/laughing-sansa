require 'rails_helper'

RSpec.describe 'events/show', type: :view do

  include Devise::TestHelpers

  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let(:event) { assign(:event, create(:event)) }

  it 'renders attributes' do
    event
    sign_in user
    render
    expect(rendered).to match(/#{event.year}/)
    expect(rendered).to match(/london/)
  end
  context 'with a signed in user' do
    before(:each) do
      event.active!
      sign_in user
    end
    it 'displays a join button if the event can be joined by the current user' do
      render
      assert_select 'a', text: 'Join game', count: 1
    end
    it 'shows a link to the players game page if they have joined' do
      create(:event_player, event: event, player: user)
      render
      assert_select 'a', text: 'Play game', count: 1
    end
    it 'hides the edit links' do
      render
      assert_select 'i', count: 0
    end
  end
  context 'as an admin' do
    before(:each) do
      event.active!
      sign_in admin
      render
    end
    it 'displays an edit link' do
      assert_select 'i.fi-pencil', count: 1
    end
    it 'displays a link to manage countries' do
      assert_select 'i.fi-flag', count: 1
    end
  end
end
