require 'rails_helper'

RSpec.describe EventPlayer, type: :model do
  let(:participant) { build(:event_player) }
  before(:each) { participant.event.active! }
  it 'passes factory build' do
    expect(participant).to be_valid
  end
  context 'associations' do
    it 'responds to scores' do
      expect(participant).to respond_to(:scores)
    end
    it 'must return scores completed' do
      expect(participant).to respond_to(:completed_scores)
    end
    it 'responds to fattest?' do
      expect(participant).to respond_to :fattest?
    end
    it 'responds to best_wail?'
    it 'repsponds to wackiest?'
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
      first = described_class.create(player: create(:user), event_id: 1, predicted_uk_score: 1)
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

  context 'joining an event with countries' do
    let(:event) { create(:event, :with_countries, number_of_countries: 2) }
    before(:each) do
      event.active!
      participant.event = event
    end
    it 'exposes the number of countries' do
      expect(participant.event.participating_countries.count).to eql(2)
    end
    context 'and saving the participant' do
      before(:each) { participant.save! }
      it 'has a score for each participating country' do
        expect(participant.scores.count).to eql(2)
      end
      it 'has 0/2 for completed scores' do
        expect(participant.completed_scores).to eql('0/2')
      end
      describe 'methods' do
        context 'when an act is marked as fattest' do
          it 'returns the country name' do
            expect(participant.fattest?).to eql(nil)
            score = participant.scores.first
            score.fattest = true
            score.save!
            expect(participant.fattest?).to eql(score.participating_country.country.name)
          end
        end
      end
    end
  end
end
