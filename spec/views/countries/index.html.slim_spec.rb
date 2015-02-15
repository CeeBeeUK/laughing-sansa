require 'rails_helper'

RSpec.describe 'countries/index', :type => :view do
  before(:each) do
    assign(:countries, [
      Country.create(name: 'country 1'),
      Country.create(name: 'country 2')
    ])
  end

  it 'renders a list of countries' do
    render
    assert_select 'li>div.name', :text => 'New Country'.to_s, :count => 1
    assert_select 'li>div.name', :count => 3
  end
end
