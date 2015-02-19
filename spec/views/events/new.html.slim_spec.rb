require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      :year => 1,
      :host_city => "MyString",
      :active => false,
      :country_id => 1
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_year[name=?]", "event[year]"

      assert_select "input#event_host_city[name=?]", "event[host_city]"

      assert_select "input#event_active[name=?]", "event[active]"

    end
  end
end
