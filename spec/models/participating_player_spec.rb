require 'rails_helper'

RSpec.describe ParticipatingPlayer, type: :model do
  let(:participant) { FactoryGirl.build :participating_player }
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
end
