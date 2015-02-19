require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = FactoryGirl.create :event
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@event.year}/)
    expect(rendered).to match(/Host city/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
