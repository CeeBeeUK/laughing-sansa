require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:event) { build(:event) }

  it 'passes factory build' do
    expect(event).to be_valid
  end

  it 'sss' do
    event = create(:event, :with_countries)
    expect(event).to be_valid
    expect(event.participating_countries.count).to eql(3)
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
    let(:event)  { create(:event) }
    it 'returns a list of players' do
      create(:event_player, event: event, player: create(:user), predicted_uk_score: 1)
      expect(event.players.count).to eq(1)
    end
  end

  describe '@complate?' do
    it 'responds true if status is archived and data complete' do
      event.archived!
      event.real_winner_id = 1
      event.home_winner_id = 1
      event.real_player_id = 1
      event.home_player_id = 1
      expect(event.complete?).to eql(true)
    end
    it 'responds true if status is archived and data complete' do
      event.archived!
      event.real_winner_id = 1
      event.home_winner_id = 1
      event.real_player_id = nil
      event.real_player_name = 'Winner'
      event.home_player_id = 1
      expect(event.complete?).to eql(true)
    end

    it 'responds false if status is archived but data incomplete' do
      event.archived!
      event.real_winner_id = nil
      event.home_winner_id = nil
      event.real_player_id = nil
      event.home_player_id = nil
      expect(event.complete?).to eql(false)
    end

    it 'responds false if status not archived' do
      event.setup!
      expect(event.complete?).to eql(false)
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
      expect(event.real_winner_display).to eql("Won by #{event.real_winning_player} with #{country.name}")
    end
    it 'displays set text if country and player is set' do
      country = create(:country)
      player = create(:user)
      event.real_winner = country
      event.real_player = player
      expect(event.real_winner_display).to eql("Won by #{event.real_winning_player} with #{country.name}")
    end
  end
  describe 'home_winner_display' do
    it 'displays set text if country and name is set' do
      country = create(:country)
      event.home_winner = country
      event.home_player_name = 'Bob'
      expect(event.home_winner_display).to eql("Home champion was #{event.home_winning_player} with #{country.name}")
    end
    it 'displays set text if country and player is set' do
      country = create(:country)
      player = create(:user)
      event.home_winner = country
      event.home_player = player
      expect(event.home_winner_display).to eql("Home champion was #{event.home_winning_player} with #{country.name}")
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
    event.date = Date.today
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
      described_class.create(
        year: 2015,
        country_id: 1,
        host_city: 'london'
      )
      duplicate = described_class.new(
        year: 2015,
        country_id: 1,
        host_city: 'london'
      )
      expect(duplicate).to be_invalid
    end
    context 'status' do
      it 'allows being set to active' do
        event.active!
        expect(event.active?).to eql(true)
        expect(event.status).to eql('active')
      end
      it 'allows being set to setup' do
        event.setup!
        expect(event.setup?).to eql(true)
        expect(event.status).to eql('setup')
      end
      it 'allows being set to archived' do
        event.archived!
        expect(event.archived?).to eql(true)
        expect(event.status).to eql('archived')
      end
      it 'fails if set to invalid value' do
        expect { event.status = 'wrong' }.to raise_error(ArgumentError, "'wrong' is not a valid status")
      end
    end
  end
end
