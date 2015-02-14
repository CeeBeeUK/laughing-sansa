require 'rails_helper'

RSpec.describe Country, :type => :model do

  let(:country) { FactoryGirl.build :country }


  it 'should pass factory build' do
      expect(country).to be_valid
  end
  describe 'validations' do
    it 'should have a name' do
      country.name = nil
      expect(country).to be_invalid
    end
  end
end
