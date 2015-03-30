require 'rails_helper'

RSpec.describe EventPlayerScore, type: :model do
  let(:eps) { build(:event_player_score) }

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

  describe 'associations' do
    it 'responds to player' do
      expect(eps).to respond_to(:player)
    end
    it 'responds to country' do
      expect(eps).to respond_to(:country)
    end
  end
end
