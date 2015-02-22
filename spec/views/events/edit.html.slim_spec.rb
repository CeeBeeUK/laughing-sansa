require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :year => 999,
      :host_city => "MyString",
      :active => false,
      :country_id => 1
    ))
    assign(:countries, [
                         Country.create(name: 'country 1'),
                         Country.create(name: 'country 2')
                     ])
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input#event_year[name=?]", "event[year]"

      assert_select "input#event_host_city[name=?]", "event[host_city]"

      assert_select "input#event_active[name=?]", "event[active]"
    end
  end
end
