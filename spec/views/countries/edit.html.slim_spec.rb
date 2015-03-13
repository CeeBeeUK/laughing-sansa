require 'rails_helper'

RSpec.describe 'countries/edit', type: :view do
  let(:country) { assign(:country, create(:country)) }

  it 'renders the edit country form' do
    country
    render
    assert_select 'form[action=?][method=?]', country_path(country), 'post' do

      assert_select 'input#country_name[name=?]', 'country[name]'

    end
  end
end
