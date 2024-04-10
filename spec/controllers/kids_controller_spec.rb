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
    subject(:post_act_score) { get :create_score, params: { eps: eps, event_player_score: { score: 10 } } }

    let(:eps) { create(:event_player_score, event:, score: 2) }
    let(:event) { create(:event) }
    let(:admin) { create(:admin_user) }

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
  end
end
