require 'rails_helper'

RSpec.feature 'Player can join game and submit score', type: :feature do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user)          { FactoryGirl.create :user }

  before do
    Capybara.current_driver = :webkit
  end

  after { Capybara.use_default_driver }

  context 'as user' do
    before(:each) do
      login_as user
    end
    after(:each) { page.driver.reset! }
    context 'not playing game' do
      it 'renders the join view' do
        expect(page).to render_template('events/join')
        # fill_in 'fee', with: '410'
        # fill_in 'children', with: '2'
        # fill_in 'income', with: '2000'
        # choose 'couple-no'
        #
        # click_button 'Check'

      end
      # scenario 'shows a successful result', js: true do
      #   expect(page).to have_xpath('//div[@class="panel callout"]', visible: true)
      #   expect(page).to have_xpath('//label[@class="error hide"]', count: 0)
      # end
      # scenario 'calculates correct values', js: true do
      #   expect(page).to have_xpath('//span[@id="fee-remit"]', text: '£200')
      #   expect(page).to have_xpath('//span[@id="fee-payable"]', text: '£210')
      # end

    end
    # context 'with invalid data' do
    #   scenario 'displays error', js: true do
    #
    #     click_button 'Check'
    #
    #     expect(page).to have_xpath('//div[@class="panel callout"]', visible: false)
    #     expect(page).to have_xpath('//label[@class="error"]', count: 3)
    #   end
    # end
  end
end
