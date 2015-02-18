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
