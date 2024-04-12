require 'rails_helper'

RSpec.describe KidsController do
  include Warden::Test::Helpers
  Warden.test_mode!
  describe 'GET /kids/:year/game' do
    # subject(:get_game) { get :game, params: { year: event.year } }
    subject(:get_game) { get kids_scoring_event_path(event.year) }

    let(:event) { create(:event, country: create(:country, name: "United Kingdom")) }
    let(:user) { create(:admin_user) }

    before do
      login_as(user, scope: :user)
      get_game
    end

    context "when the current user is an admin" do
      it 'renders the expected page' do
        expect(response.status).to eq(200)
      end
    end

    context "when the current user is not an admin" do
      let(:user) { create(:user) }

      it 'returns a redirect status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirect to event page' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET /kids/:year/score/:act' do
    subject(:score_act) { get kids_scoring_act_path(event.year, act) }

    context "when scoring the first act" do
      before do
        Event.delete_all
        Country.delete_all
        User.delete_all
        ParticipatingCountry.delete_all
        EventPlayer.delete_all
        create(:participating_country, event:,  country: host, position: 1, player: admin)
        create(:participating_country, event:, country: create(:country, name: "France"), position: 2, player: admin)
        create(:participating_country, event:, country: create(:country, name: "Germany"), position: 3, player: player)
        create(:event_player, player:, event:)
        create(:user, encrypted_password: "non-blank") # active_player
        login_as(admin, scope: :user)
      end

      let(:act) { 1 }
      let(:admin) { create(:admin_user, encrypted_password: "non-blank") }
      let(:event) { create(:event, country: host, real_player: nil, home_player: nil) }
      let(:host) { create(:country, name: "United Kingdom") }
      let(:player) { create(:user) }

      it "renders the country name and a single Submit score button" do
        expect(User.count).to eql 3
        expect(User.where(encrypted_password: "").count).to eql 1
        score_act
        expect(response.body).to include("Act 1 - United Kingdom")
        expect(response.body).to include("Submit score").once
      end
    end

    context "when scoring the second act" do
      before do
        Event.delete_all
        Country.delete_all
        User.delete_all
        ParticipatingCountry.delete_all
        EventPlayer.delete_all
        create(:participating_country, event:,  country: host, position: 1, player: admin)
        create(:participating_country, event:, country: create(:country, name: "France"), position: 2, player: player)
        create(:participating_country, event:, country: create(:country, name: "Germany"), position: 3, player: admin)
        create(:event_player, player:, event:)
        create(:user, encrypted_password: "non-blank") # active_player
        login_as(admin, scope: :user)
      end

      let(:act) { 2 }
      let(:admin) { create(:admin_user, encrypted_password: "non-blank") }
      let(:event) { create(:event, country: host, real_player: nil, home_player: nil) }
      let(:host) { create(:country, name: "United Kingdom") }
      let(:player) { create(:user) }

      it "renders the country name" do
        expect(User.count).to eql 3
        expect(User.where(encrypted_password: "").count).to eql 1
        score_act
        expect(response.body).to include("Act 2 - France")
        expect(response.body).to include("Submit score").once
      end
    end
  end
end
