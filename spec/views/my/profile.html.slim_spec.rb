require 'rails_helper'

RSpec.describe 'my/profile.html.slim', type: :view do

  include Devise::Test::ControllerHelpers

  let(:user) { assign(:user, create(:user)) }
  before(:each) do
    sign_in user
  end

  it 'shows the email address' do
    render
    expect(rendered).to include(user.email)
  end
  context 'when user has no display name set' do
    it 'show instructions to set' do
      user.display_name = ''
      render
      assert_select 'div.alert-box.info.radius', text: /set a display name below,/, count: 1
    end
  end
  context 'user has a display name set' do
    it 'hide instructions to set' do
      user.display_name = 'bob'
      render
      assert_select 'div.alert-box.info.radius', text: /set a display name below,/, count: 0
    end
  end
end
