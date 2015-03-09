require 'rails_helper'

RSpec.describe "participating_player/new.html.slim", type: :view do
  
  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin_user }
  let(:event) { assign(:event, FactoryGirl.create(:event, status: 2)) }

  it "renders the new form" do
    params = {}
    params[:year] = event.year
    assign(:year, 2015)
  	@participating_player = ParticipatingPlayer.new
  	@participating_player.player = user
  	@participating_player.event = event
  	sign_in admin
    render
    expect(rendered).to include(', thanks for joining')
   end
end
