require 'rails_helper'

RSpec.describe 'events/index', type: :view do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }

  before(:each) do
    country = FactoryGirl.create :country
    assign(:events, [
      Event.create!(
        year: 2010,
        host_city: 'Host City',
        active: false,
        country: country,
        status: 'archived',
        real_winner: country,
        home_winner: country,
        real_player_name: 'bob',
        home_player_name: 'bob'
      ),
      Event.create!(
        year: 2011,
        host_city: 'Host City',
        active: false,
        country: country,
        status: 'archived',
        real_winner: country,
        home_winner: country,
        real_player_name: 'bob',
        home_player_name: 'bob'
      ),
      Event.create!(
        year: 2012,
        host_city: 'Host City',
        active: true,
        country: country,
        status: 'setup',
        real_winner: nil,
        home_winner: nil,
        real_player_name: nil,
        home_player_name: nil
      )
    ])
  end

  it 'renders a list of events' do
    sign_in user
    render
    assert_select 'li span.year', :text => 2010.to_s, :count => 1
    assert_select 'li span.year', :text => 2011.to_s, :count => 1
    assert_select 'li span.host-city', :text => 'Host City'.to_s, :count => 3
    assert_select 'li div.winner', text: /Won by/, :count => 2
    assert_select 'li div.home', text: /Home Champion was/, :count => 2
  end
end
