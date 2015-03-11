require 'rails_helper'

RSpec.describe 'events/new', type: :view do
  let(:event) {
    assign(:event,
      Event.new(
        year: 1,
        host_city: 'MyString',
        active: false,
        country_id: 1
      )
    )
  }
  let(:countries) {
    assign(:countries,
      [
        Country.create(name: 'country 1'),
        Country.create(name: 'country 2')
      ]
    )
  }
  let(:users) {
    assign(:users,
      [
        create(:user),
        create(:user)
      ]
    )
  }

  it 'renders new event form' do
    countries
    event
    render

    assert_select 'form[action=?][method=?]', events_path, 'post' do

      assert_select 'input#event_year[name=?]', 'event[year]'

      assert_select 'input#event_host_city[name=?]', 'event[host_city]'

      assert_select 'input#event_active[name=?]', 'event[active]'

    end
  end
end
