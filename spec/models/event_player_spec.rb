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
    it 'responds to best_wail?' do
      expect(participant).to respond_to :best_wail?
    end
    it 'repsponds to wackiest?' do
      expect(participant).to respond_to :wackiest?
    end
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
      first = described_class.create(player: create(:user), event: create(:event), predicted_uk_score: 1)
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
        describe 'reset_values' do
          it 'when passed two strings clears original value and sets new one' do
            participant.scores.each do |p|
              p.fattest = false
              p.save
            end
            score = participant.scores.first
            score2 = participant.scores.last

            score.fattest = true
            score.best_wail = true
            score.save!
            expect(participant.fattest?).to eql(score.participating_country)
            expect(participant.best_wail?).to eql(score.participating_country)

            participant.set_attribute_to_true('fattest', score2.participating_country)

            expect(participant.fattest?).to eql(score2.participating_country)
            expect(participant.best_wail?).to eql(score.participating_country)
          end
        end
        describe 'when number of acts marked as' do
          context 'fattest' do
            it 'is zero, returns nil' do
              participant.scores.each do |p|
                p.fattest = false
                p.save
              end
              expect(participant.fattest?).to eql(nil)
            end
            it 'is one, returns the country name' do
              score = participant.scores.first
              score.fattest = true
              score.save!
              expect(participant.fattest?).to eql(score.participating_country)
            end
          end
          context 'wackiest' do
            it 'is zero, returns nil' do
              participant.scores.each do |p|
                p.wackiest = false
                p.save
              end
              expect(participant.wackiest?).to eql(nil)
            end
            it 'is one, returns the country name' do
              score = participant.scores.first
              score.wackiest = true
              score.save!
              expect(participant.wackiest?).to eql(score.participating_country)
            end
          end
          context 'best_wail' do
            it 'is zero, returns nil' do
              participant.scores.each do |p|
                p.best_wail = false
                p.save
              end
              expect(participant.best_wail?).to eql(nil)
            end
            it 'is one, returns the country' do
              score = participant.scores.first
              score.best_wail = true
              score.save!
              expect(participant.best_wail?).to eql(score.participating_country)
            end
          end
        end
      end
    end
  end
end
