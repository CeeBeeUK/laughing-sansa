require 'rails_helper'

RSpec.describe "ParticipatingPlayers", :type => :request do

  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { FactoryGirl.create :user }
  let(:admin_user) { FactoryGirl.create :admin_user }
   before(:each) do
   	if Event.first
   		@event = Event.first
   		@event.active!
	  else
	    @event = assign(:event, Event.create!(
	      year: 998,
	      host_city: "MyString",
	      active: false,
	      country_id: 1,
	      real_winner_id: nil,
	      real_score: nil,
	      real_player_id: nil,
	      real_player_name: nil,
	      home_winner_id: nil,
	      home_score: nil,
	      home_player_id: nil,
	      home_player_name: nil,
	      status: 'active'
	    ))
	  end
  end

  describe "GET /events/2015/join" do
    it "Redirects us when not authenticated." do
      get new_join_game_path(year: @event.year)
      expect(response.status).to eql(302)
    end

    it "as user serves the required page" do
      login_as(user, :scope => :user)
      get new_join_game_path(year: @event.year)
      expect(response.status).to eql(200)
    end

    it "as admin serves the required page" do
      login_as(admin_user, :scope => :user)
      get new_join_game_path(year: @event.year)
      expect(response.status).to eql(200)
    end
  end
end
