require 'rails_helper'

RSpec.describe 'countries/show', type: :view do
  before(:each) do
    @country =  create(:country)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
