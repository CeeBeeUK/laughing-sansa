require 'rails_helper'

RSpec.describe 'events/show', type: :view do

  include Devise::TestHelpers

  let(:user) { create(:user) }
  let(:event) { assign(:event, create(:event)) }

  it 'renders attributes' do
    event
    sign_in user
    render
    expect(rendered).to match(/#{event.year}/)
    expect(rendered).to match(/london/)

  end
end
