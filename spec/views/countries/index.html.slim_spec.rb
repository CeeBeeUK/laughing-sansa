require 'rails_helper'

RSpec.describe 'countries/index', type: :view do

  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  before(:each) do
    assign(:countries,
      [
        Country.create(name: 'country 1'),
        Country.create(name: 'country 2')
      ])
  end

  it 'renders a list of countries' do
    sign_in user
    render
    assert_select 'li>a>span', text: 'New Country'.to_s, count: 1
    assert_select 'li>a>span.name', count: 2
  end
end
