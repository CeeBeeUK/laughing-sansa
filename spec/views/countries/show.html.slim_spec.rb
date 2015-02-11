require 'rails_helper'

RSpec.describe "countries/show", :type => :view do
  before(:each) do
    @country = assign(:country, Country.create!(
      :name => "Name",
      :image_path => "Image Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Image Path/)
  end
end
