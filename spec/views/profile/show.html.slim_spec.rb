require 'rails_helper'

RSpec.describe "profile/show.html.slim", type: :view do

  include Devise::TestHelpers

  let(:user) { assign(:user, FactoryGirl.create(:user)) }
  before(:each) do
    sign_in user
  end

  it 'should show the email address' do
    render
    expect(rendered).to include(user.email)
  end
  context 'user has no display name set' do
    it 'should show instructions to set' do
      user.display_name = ''
      render
      assert_select 'div.alert-box.info.radius', text: /set a display name below,/, :count => 1
    end
  end
  context 'user has a display name set' do
    it 'should not show instructions to set' do
      user.display_name = 'bob'
      render
      assert_select 'div.alert-box.info.radius', text: /set a display name below,/, :count => 0
    end
  end
end
