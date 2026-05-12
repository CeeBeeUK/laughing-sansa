require 'rails_helper'

RSpec.describe KidsController do
  describe 'GET /kids/:year/join/:player' do
    subject(:join_game) { get :join_game, params: { year: event.year, player: joiner } }

    let(:joiner) { create(:user) }
    let(:admin) { create(:admin_user) }
    let(:event) { create(:event, :with_countries) }

    it { expect(joiner.encrypted_password).to eql "" }
    it { expect(EventPlayer.where(player: joiner).count).to eql 0 }

    context "when submitting the get request" do
      before do
        player = create(:user)
        create(:event_player, event:, player:)
        sign_in admin
      end

      it "redirects to the scoring event page" do
        join_game
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(kids_scoring_event_path(event))
      end

      it "saves the new event player" do
        expect(joiner.in_event?(event)).to be false
        expect { join_game }.to change(EventPlayer, :count).by(1)
        expect(joiner.in_event?(event)).to be true
      end

      it "creates new event player scores" do
        expect { join_game }.to change(EventPlayerScore, :count).by(3)
      end
    end
  end
  
  describe 'POST /kids/score/:eps' do
    subject(:post_act_score) { post :create_score, params: }

    let(:eps) { create(:event_player_score, participating_country: pc, event_player: ep, score: 2) }
    let(:ep) { create(:event_player, event:) }
    let(:pc) { create(:participating_country, position: 1, event:) }
    let(:event) { create(:event) }
    let(:admin) { create(:admin_user) }
    let(:params) do
      {
        year: eps.event.year,
        act: eps.participating_country.position,
        "[#{eps.id}]score": 10 }
    end

    before { sign_in admin }

    it "updates the record" do
      expect(eps.score).to eql 2
      post_act_score
      expect(eps.reload.score).to eql 10
    end

    it "redirects to the scoring event page" do
      post_act_score
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(kids_scoring_event_path(event))
    end

    context "when there are two players" do
      let(:eps2) { create(:event_player_score, participating_country: pc, event_player: ep, score: 5) }
      let(:params) do
        {
          year: eps.event.year,
          act: eps.participating_country.position,
          "[#{eps.id}]score": 10,
          "[#{eps2.id}]score": 12 }
      end

      it "updates both records" do
        expect(eps.score).to eql 2
        expect(eps2.score).to eql 5
        post_act_score
        expect(eps.reload.score).to eql 10
        expect(eps2.reload.score).to eql 12
      end
    end
  end
end
