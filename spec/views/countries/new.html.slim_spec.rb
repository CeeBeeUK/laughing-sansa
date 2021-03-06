require 'rails_helper'

RSpec.describe 'countries/new', type: :view do
  before do
    @country = Country.create(name: nil)
  end

  it 'renders new country form' do
    render

    assert_select 'form[action=?][method=?]', countries_path, 'post' do
      assert_select 'input#country_name[name=?]', 'country[name]'
    end
  end
end
