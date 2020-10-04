require 'rails_helper'

RSpec.describe 'countries/index', type: :view do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }

  before do
    assign(:countries,
      [
        Country.create(name: 'Albania'),
        Country.create(name: 'Australia')
      ])
  end

  it 'renders a list of countries' do
    sign_in user
    render
    assert_select 'li>a>span', text: 'Albania'.to_s, count: 1
    assert_select 'li>a>span.name', count: 2
  end
end
