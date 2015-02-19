require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :year => 2010,
        :host_city => "Host City",
        :active => false,
        :country_id => 1
      ),
      Event.create!(
        :year => 2011,
        :host_city => "Host City",
        :active => false,
        :country_id => 2
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "li>span.year", :text => 2010.to_s, :count => 1
    assert_select "li>span.year", :text => 2011.to_s, :count => 1
    assert_select "li>span.host", :text => "Host City".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
