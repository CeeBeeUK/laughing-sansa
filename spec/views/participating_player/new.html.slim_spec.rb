require 'rails_helper'

RSpec.describe "particpating_player/new.html.slim", type: :view do
  
  include Devise::TestHelpers

  let(:user) { FactoryGirl.create :user }
  let(:admin) { FactoryGirl.create :admin_user }

  it "renders the new form" do
  	sign_in admin
    render
	expect(rendered).to include(', thanks for joining')
   end
end
