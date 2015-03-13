require 'rails_helper'

RSpec.describe "events/new", type: :view do

  it "renders new event form" do
    assign(:event, Event.create(
                     year: 1,
                     host_city: "MyString",
                     active: false,
                     country_id: 1
                 ))
    assign(:countries,
      [
        Country.create(name: 'country 1'),
        Country.create(name: 'country 2')
      ]
    )
    assign(:users,
      [
        create(:user),
        create(:user)
      ]
    )
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_year[name=?]", "event[year]"

      assert_select "input#event_host_city[name=?]", "event[host_city]"

      assert_select "input#event_active[name=?]", "event[active]"

    end
  end
end
