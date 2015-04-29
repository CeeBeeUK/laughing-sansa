require 'rails_helper'

RSpec.describe EventPlayerScore, type: :model do
  let(:eps) { build(:event_player_score) }

  it 'passes factory build' do
    expect(eps).to be_valid
  end

  describe 'validation' do
    it 'requires a score' do
      eps.score = nil
      expect(eps).to be_invalid
    end
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
end
