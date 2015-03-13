require 'rails_helper'

RSpec.describe 'events/new', type: :view do

  let(:event) { assign(:event, create(:event)) }

  it 'renders new event form' do
    assign(:countries, [create(:country), create(:country)])
    assign(:users, [create(:user), create(:user)])

    event
    render
    assert_select 'form[action=?][method=?]', event_path(event), 'post' do

      assert_select 'input#event_year[name=?]', 'event[year]'

      assert_select 'input#event_host_city[name=?]', 'event[host_city]'

      assert_select 'input#event_active[name=?]', 'event[active]'

    end
  end
end
