require 'rails_helper'

RSpec.describe ParticipatingCountry, type: :model do
  let(:participant) { create(:participating_country) }

  it 'passes the factory build' do
    expect(participant).to be_valid
  end

  context 'methods' do
    it 'returns a sum value' do
      expect(participant).to respond_to(:sum)
    end
  end

  describe 'scopes' do
    describe 'player_for_event' do
      let(:user) { create(:user) }
      let!(:event1) { create(:event) }
      let!(:event2) { create(:event) }

      it 'lists countries for player in the given event' do
        create_list :participating_country, 3, event: event1, player: user
        create_list :participating_country, 3, event: event2, player: user
        event1.save!

        result = described_class.player_for_event(event1, user)
        expect(result.count).to be 3
      end
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
      let(:first) { create(:participating_country) }
      let(:duplicate) { first.dup }

      it 'is invalid with a duplicate number' do
        expect(duplicate).to be_invalid
      end

      it 'must have a unique position and country' do
        duplicate.position += 1
        duplicate.country = create(:country)
        expect(duplicate).to be_valid
      end
    end
  end
end
