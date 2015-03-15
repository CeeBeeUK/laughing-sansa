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

  it 'adds a join button if the event is active and the user is not currently playing' do
    event.active!
    sign_in user
    render
    assert_select 'a', text: 'Join', count: 1
  end
end
