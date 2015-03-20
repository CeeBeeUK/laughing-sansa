require 'rails_helper'

RSpec.describe EventPlayer, type: :model do
  let(:participant) { build(:event_player) }
  before(:each) { participant.event.active! }
  it 'passes factory build' do
    expect(participant).to be_valid
  end
  context 'validations' do
    it 'must require an event' do
      participant.event = nil
      expect(participant).to be_invalid
    end
    it 'must require a player' do
      participant.player = nil
      expect(participant).to be_invalid
    end
    it 'must have a prediction' do
      participant.predicted_uk_score = nil
      expect(participant).to be_invalid
    end
    it 'must have a positive prediction' do
      participant.predicted_uk_score = -1
      expect(participant).to be_invalid
    end
    it 'player must be unique for an event' do
      first = described_class.create(player_id: 1, event_id: 1, predicted_uk_score: 1)
      first.event.active!
      first.save!
      duplicate = first.dup
      expect(duplicate).to be_invalid
    end
  end
  context 'joining an event' do
    let(:event) { build(:event) }
    it 'in setup should fail' do
      event.setup!
      participant.event = event
      expect(participant).to be_invalid
    end
    it 'in archived should fail' do
      event.archived!
      participant.event = event
      expect(participant).to be_invalid
    end
    it 'in active should succeed' do
      event.active!
      participant.event = event
      expect(participant).to be_valid
    end
  end
end
