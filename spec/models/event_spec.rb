require 'rails_helper'

RSpec.describe Event, type: :model do

  let(:event) { FactoryGirl.build :event }

  it 'should pass factory build' do
    expect(event).to be_valid
  end

  describe "associations" do
    it "should have a directorate attribute" do
      expect(event).to respond_to(:country)
    end
  end
  describe 'real_winning_player' do
    describe 'outputs' do
      it 'real_winner_name if set' do
        event.real_winner_id = nil
        event.real_player_name = 'Bob'
        expect(event.real_winning_player).to eql('Bob')
      end
      it 'linked players display_name if set' do
        player = FactoryGirl.create :user
        event.real_player = player
        event.real_player_name = 'Bob'
        expect(event.real_winning_player).to eql(player.display_name)
      end
    end
  end
  describe 'home_winning_player' do
    describe 'outputs' do
      it 'home_winner_name if set' do
        event.home_winner_id = nil
        event.home_player_name = 'Bob'
        expect(event.home_winning_player).to eql('Bob')
      end
      it 'linked players display_name if set' do
        player = FactoryGirl.create :user
        event.home_player = player
        event.home_player_name = 'Bob'
        expect(event.home_winning_player).to eql(player.display_name)
      end
    end
  end
  context 'validations' do
    it 'should have a country' do
      event.country = nil
      expect(event).to be_invalid
    end
    it 'should have a year' do
      event.year = nil
      expect(event).to be_invalid
    end
    it 'should have a unique year' do
      Event.create({
                       year: 2015,
                       country_id: 1,
                       host_city: 'london'
                   })
      duplicate = Event.new({
                                year: 2015,
                                country_id: 1,
                                host_city: 'london'
                            })
      expect(duplicate).to be_invalid
    end
  end
end
