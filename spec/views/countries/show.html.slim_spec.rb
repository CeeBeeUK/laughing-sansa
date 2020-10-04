require 'rails_helper'

RSpec.describe 'countries/show', type: :view do
  before do
    @country = create(:country, name: 'Albania')
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
