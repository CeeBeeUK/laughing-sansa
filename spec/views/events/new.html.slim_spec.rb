require 'rails_helper'

RSpec.describe 'events/new', type: :view do
  let(:event) { assign(:event, create(:event)) }

  it 'renders new event form' do
    event
    render

    assert_select 'form[action=?][method=?]', events_path, 'post' do

      assert_select 'input#event_year[name=?]', 'event[year]'

      assert_select 'input#event_host_city[name=?]', 'event[host_city]'

      assert_select 'input#event_active[name=?]', 'event[active]'

    end
  end
end
