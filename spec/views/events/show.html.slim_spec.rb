require 'rails_helper'

RSpec.describe 'events/show', type: :view do

  include Devise::TestHelpers

  let(:user) { create(:user) }

  before(:each) do
    @event = create(:event)
    @event.country = create(:country)
  end

  it 'renders attributes' do
    sign_in user
    render
    expect(rendered).to match(/#{@event.year}/)
    expect(rendered).to match(/london/)

  end
end
