require 'rails_helper'

RSpec.describe 'events/edit', type: :view do
  let(:event) do
    assign(:event,
      Event.create!(
        year: 999,
        host_city: 'MyString',
        active: false,
        country: Country.create(name: "Country zero"),
        real_winner_id: nil,
        real_score: nil,
        real_player_id: nil,
        real_player_name: nil,
        home_winner_id: nil,
        home_score: nil,
        home_player_id: nil,
        home_player_name: nil,
        status: nil
      ))
  end

  before do
    event
    assign(:countries,
      [
        Country.create(name: 'country 1'),
        Country.create(name: 'country 2')
      ])
    assign(:users,
      [
        create(:user),
        create(:user)
      ])
    render
  end

  it 'renders the edit event form' do
    assert_select 'form[action=?][method=?]', event_path(event), 'post' do
      assert_select 'input#event_year[name=?]', 'event[year]'
      assert_select 'input#event_host_city[name=?]', 'event[host_city]'
      assert_select 'input#event_active[name=?]', 'event[active]'
    end
  end
end
