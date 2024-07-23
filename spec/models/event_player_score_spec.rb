require 'rails_helper'

RSpec.describe EventPlayerScore, type: :model do
  let(:eps) { create(:event_player_score) }

  it 'passes factory build' do
    expect(eps).to be_valid
  end

  describe 'validation' do
    it 'requires an event_player' do
      eps.event_player = nil
      expect(eps).to be_invalid
    end
    it 'requires a participating country' do
      eps.participating_country = nil
      expect(eps).to be_invalid
    end
  end
  describe 'scores' do
    it 'must be positive' do
      eps.score = -1
      expect(eps).to be_invalid
    end
    it 'must be in the array' do
      GlobalConstants::VALID_SCORES.each do |s|
        eps.score = s
        expect(eps).to be_valid
      end
    end
  end
  describe 'methods' do
    it 'returns the players display name' do
      eps.event_player = create(:event_player)
      expect(eps.player).to eql(eps.event_player.player.display_name)
    end
    it 'returns the participating_country' do
      eps.participating_country = create(:participating_country)
      expect(eps.country).to eql(eps.participating_country.country.name)
    end
    it 'sets a sum for the participating country' do
      expect(eps.participating_country.sum).to eq 1
    end
  end
  describe 'associations' do
    it 'responds to player' do
      expect(eps).to respond_to(:player)
    end
    it 'responds to country' do
      expect(eps).to respond_to(:country)
    end
    it 'responds to event (through event_player' do
      expect(eps).to respond_to(:event)
    end
  end
  describe 'scopes' do
    before { described_class.delete_all }
    let(:ep) { create(:event_player) }

    describe 'scoring_order' do
      before do
        create_list :event_player_score, 3, event_player: ep, score: nil
        result = described_class.scoring_order(ep.id)
        result.first.update(score: 10)
      end
      it 'lists by position and score' do
        expect(described_class.scoring_order(ep.id).last.score).to be 10
      end
    end
    describe 'playing_order' do
      it 'lists by participating_country.position' do
        create_list :event_player_score, 4, event_player: ep
        result = described_class.playing_order(ep.id)
        expect(result.first.participating_country.position).to be < result.last.participating_country.position
      end
    end
  end
end
