require 'rails_helper'

RSpec.describe Country, :type => :model do

  let(:country) { FactoryGirl.build :country }


  it 'should pass factory build' do
      expect(country).to be_valid
  end

  context 'with no image set' do
    it 'should return a small image path from the country name' do
      expect(country.small_image).to eql('assets/16/united_kingdom.png')
    end

    it 'should return a large image path from the country name' do
      expect(country.large_image).to eql('assets/32/united_kingdom.png')
    end

    it 'should return a XL image path from the country name' do
      expect(country.xl_image).to eql('assets/64/united_kingdom.png')
    end

    context 'requesting disabled badge' do
      xit 'should return a b&w large image from the country name' do
        expect(country.disabled_image).to eql('assets/64/united_kingdom_bw.png')
      end
    end
  end

  context 'with image path set' do
    before(:each) { country.image_path = 'country' }

    it 'should return a small path' do
      expect(country.small_image).to eql('assets/16/country.png')
    end
    it 'should return a large path' do
      expect(country.large_image).to eql('assets/32/country.png')
    end
    it 'should return a XL image path from the country name' do
      expect(country.xl_image).to eql('assets/64/country.png')
    end

    context 'requesting disabled badge' do
      xit 'should return a b&w large image from the country name' do
        expect(country.disabled_image).to eql('assets/64/country_bw.png')
      end
    end
  end

  describe 'validations' do
    it 'should have a name' do
      country.name = nil
      expect(country).to be_invalid
    end
  end
end
