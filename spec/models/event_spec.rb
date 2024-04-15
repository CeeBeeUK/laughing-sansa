require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { build(:event) }

  it 'passes factory build' do
    expect(event).to be_valid
  end

  context 'automatically adds the "big 5" when created' do
    before do
      Country.delete_all
      described_class.delete_all
      create(:country, name: 'Italy')
      create(:country, name: 'Spain')
      create(:country, name: 'Germany')
      create(:country, name: 'France')
      create(:country, name: 'United Kingdom')
      create(:country, name: 'Serbia')
    end

    context 'when the host is non-big 5' do
      let(:event) { create(:event, country: Country.find_by(name: 'Serbia')) }

      it "adds the big five as well as the host" do
        event.add_big_five
        expect(event.participating_countries.count).to eql 6
      end
    end
    context 'when the host is one of the big 5' do
      let(:uk) { Country.find_by(name: 'United Kingdom') }
      let(:event) { create(:event, country: uk) }

      it 'does not create duplicate countries' do
        event.add_big_five
        expect(event.participating_countries.count).to eql 5
      end
    end
  end

  describe 'associations' do
    it 'responds to participating_countries' do
      expect(event).to respond_to(:participating_countries)
    end
    it 'respond to country' do
      expect(event).to respond_to(:country)
    end
    it 'responds to complete?' do
      expect(event).to respond_to(:complete?)
    end
    it 'responds to players' do
      expect(event).to respond_to(:players)
    end
  end
  describe 'players' do
    let(:event) { create(:event) }

    it 'returns a list of players' do
      create(:event_player, event: event, player: create(:user), predicted_uk_score: 1)
      expect(event.players.count).to eq(1)
    end
  end
  describe 'scopes' do
    describe 'players_predictions_high_to_low' do
      let!(:event) { create(:event) }
      let(:results) { event.players_predictions_high_to_low }

      before do
        create(:event_player, event: event, predicted_uk_score: 45, player: create(:user))
        create(:event_player, event: event, predicted_uk_score: 102, player: create(:user))
        create(:event_player, event: event, predicted_uk_score: 3, player: create(:user))
      end
      describe 'returns players in descending prediction order' do
        it { expect(results.count).to be 3 }
        it { expect(results.first.predicted_uk_score).to be 102 }
        it { expect(results.last.predicted_uk_score).to be 3 }
      end
    end
  end
  describe '@complete?' do
    context 'when status is archived' do
      before do
        event.archived!
      end

      context 'when data complete' do
        before do
          event.real_winner_id = 1
          event.home_winner_id = 1
          event.real_player_id = 1
          event.home_player_id = 1
        end

        it 'responds true' do
          expect(event.complete?).to be true
        end
      end
      context 'when data partially complete' do
        before do
          event.real_winner_id = 1
          event.home_winner_id = 1
          event.real_player_id = nil
          event.real_player_name = 'Winner'
          event.home_player_id = 1
        end

        it 'responds true when data partial' do
          expect(event.complete?).to be true
        end
      end

      context 'when data incomplete' do
        before do
          event.real_winner_id = nil
          event.home_winner_id = nil
          event.real_player_id = nil
          event.home_player_id = nil
        end

        it 'responds false' do
          expect(event.complete?).to be false
        end
      end
    end

    it 'responds false if status not archived' do
      event.setup!
      expect(event.complete?).to be false
    end
  end
  describe 'player_won?' do
    it 'returns true when the real player value is set' do
      player = create(:user)
      event.home_player = nil
      event.real_player = player
      expect(event.player_won?(player.id)).to be true
    end
    it 'returns true when the home player value is set' do
      player = create(:user)
      event.real_player = nil
      event.home_player = player
      expect(event.player_won?(player.id)).to be true
    end
  end
  describe 'real_winning_player' do
    describe 'outputs' do
      it 'real_winner_name if set' do
        event.real_player_id = nil
        event.real_player_name = 'Bob'
        expect(event.real_winning_player).to eql('Bob')
      end
      it 'linked players display_name if set' do
        player = create(:user)
        event.real_player = player
        event.real_player_name = 'Bob'
        expect(event.real_winning_player).to eql(player.display_name)
      end
    end
  end
  describe 'real_winner_display' do
    it 'displays set text if country and name is set' do
      country = create(:country)
      event.real_winner = country
      event.real_player_name = 'Bob'
      expect(event.real_winner_display).to eql("#{event.real_winning_player} with #{country.name}")
    end
    it 'displays set text if country and player is set' do
      country = create(:country)
      player = create(:user)
      event.real_winner = country
      event.real_player = player
      expect(event.real_winner_display).to eql("#{event.real_winning_player} with #{country.name}")
    end
  end
  describe 'home_winner_display' do
    it 'displays set text if country and name is set' do
      country = create(:country)
      event.home_winner = country
      event.home_player_name = 'Bob'
      expect(event.home_winner_display).to eql("#{event.home_winning_player} with #{country.name}")
    end
    it 'displays set text if country and player is set' do
      country = create(:country)
      player = create(:user)
      event.home_winner = country
      event.home_player = player
      expect(event.home_winner_display).to eql("#{event.home_winning_player} with #{country.name}")
    end
  end
  describe 'home_winning_player' do
    describe 'outputs' do
      it 'home_winner_name if set' do
        event.home_player_id = nil
        event.home_player_name = 'Bob'
        expect(event.home_winning_player).to eql('Bob')
      end
      it 'linked players display_name if set' do
        player = create(:user)
        event.home_player = player
        event.home_player_name = 'Bob'
        expect(event.home_winning_player).to eql(player.display_name)
      end
    end
  end
  it 'allows a date to be set' do
    event.date = Time.zone.today
    expect(event).to be_valid
  end
  context 'validations' do
    it 'requires a country' do
      event.country = nil
      expect(event).to be_invalid
    end
    it 'requires a year' do
      event.year = nil
      expect(event).to be_invalid
    end
    it 'requires a unique year' do
      described_class.create(year: 2015, country_id: 1, host_city: 'london')
      duplicate = described_class.new(year: 2015, country_id: 1, host_city: 'london')
      expect(duplicate).to be_invalid
    end
    context 'status' do
      describe 'allows being set to active' do
        before { event.active! }
        it { expect(event.active?).to be true }
        it { expect(event.status).to eql('active') }
      end
      describe 'allows being set to setup' do
        before { event.setup! }
        it { expect(event.setup?).to be true }
        it { expect(event.status).to eql('setup') }
      end
      describe 'allows being set to archived' do
        before { event.archived! }
        it { expect(event.archived?).to be true }
        it { expect(event.status).to eql('archived') }
      end
      it 'fails if set to invalid value' do
        expect { event.status = 'wrong' }.to raise_error(ArgumentError, "'wrong' is not a valid status")
      end
    end
  end
end
