require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  include Devise::Test::ControllerHelpers
  before { Event.delete_all }
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let(:country) { create(:country, name: 'Albania') }
  let(:event) { create(:event, country: country) }

  context 'all visitors' do
    it 'have access to an off canvas menu' do
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list', count: 1
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Home', count: 1
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Sign out', count: 0
    end
  end
  context 'signed in users' do
    it 'have a sign out option' do
      sign_in user
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Sign out', count: 1
    end
  end
  context 'signed in admin' do
    before { sign_in admin }
    it 'have a sign out option' do
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Sign out', count: 1
    end
    it 'has an admin header' do
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>label', text: 'Admin functions', count: 1
    end
    it 'has a link to maintain countries' do
      render
      assert_select 'nav.left-off-canvas-menu>ul.off-canvas-list>li>a', text: 'Countries', count: 1
    end
  end
end
