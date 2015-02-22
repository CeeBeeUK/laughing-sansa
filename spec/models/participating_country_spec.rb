require 'rails_helper'

RSpec.describe ParticipatingCountry, type: :model do
  let(:participant) { FactoryGirl.build :participating_country }

  it 'should pass the factory build' do
    expect(participant).to be_valid
  end
  context 'validations' do
    it 'must require a country' do
      participant.country=nil
      expect(participant).to be_invalid
    end

    it 'must require an event' do
      participant.event = nil
      expect(participant).to be_invalid
    end

    it 'must require a player' do
      participant.player = nil
      expect(participant).to be_invalid
    end

    it 'must have a sequence' do
      participant.sequence = nil
      expect(participant).to be_invalid
    end

    context 'within an event' do
      it 'must have a unique sequence and country' do
        first = FactoryGirl.create :participating_country
        duplicate = first.dup

        expect(duplicate).to be_invalid
        duplicate.sequence += 1
        expect(duplicate).to be_invalid
        duplicate.country = FactoryGirl.create(:country)
        expect(duplicate).to be_valid
        duplicate.sequence = first.sequence
        expect(duplicate).to be_invalid
      end
    end
  end
end
