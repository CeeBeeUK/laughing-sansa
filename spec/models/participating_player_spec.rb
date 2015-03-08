require 'rails_helper'

RSpec.describe ParticipatingPlayer, type: :model do
  let(:participant) { FactoryGirl.build :participating_player }
  before(:each) { participant.event.active! }
  it 'should pass factory build' do
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
  end
  context 'joining an event' do
    let (:event) { FactoryGirl.build :event }
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
