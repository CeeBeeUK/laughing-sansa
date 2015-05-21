require 'rails_helper'

RSpec.describe ParticipatingCountry, type: :model do
  let(:participant) { build(:participating_country) }

  it 'passes the factory build' do
    expect(participant).to be_valid
  end

  context 'methods' do
    it 'returns a sum value' do
      expect(participant).to respond_to(:sum)
    end
  end
  context 'validations' do
    it 'must require a country' do
      participant.country = nil
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

    it 'must have a position' do
      participant.position = nil
      expect(participant).to be_invalid
    end

    context 'within an event' do
      it 'must have a unique position and country' do
        first = create(:participating_country)
        duplicate = first.dup

        expect(duplicate).to be_invalid
        duplicate.position += 1
        expect(duplicate).to be_invalid
        duplicate.country = create(:country)
        expect(duplicate).to be_valid
        duplicate.position = first.position
        expect(duplicate).to be_invalid
      end
    end
  end
end
