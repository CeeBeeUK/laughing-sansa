require 'rails_helper'

RSpec.describe "layouts/application.html.slim", :type => :view do

  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }

  context 'all visitors' do
    it 'should have access to an off canvas menu' do
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list', :count => 1
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Home', :count => 1
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Sign out', :count => 0
    end
  end
  context 'signed in users' do
    it 'should have a sign out option' do
      sign_in user
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Sign out', :count => 1

    end
  end
end
