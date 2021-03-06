require 'rails_helper'

RSpec.describe Country, type: :model do
  before { described_class.delete_all }
  let(:country) { build(:country, name: 'Italy') }

  it 'passes factory build' do
    expect(country).to be_valid
  end

  context 'with no image set' do
    it 'returns a small image path from the country name' do
      expect(country.small_image).to eql('16/italy.png')
    end

    it 'returns a large image path from the country name' do
      expect(country.large_image).to eql('32/italy.png')
    end

    it 'returns a XL image path from the country name' do
      expect(country.xl_image).to eql('64/italy.png')
    end

    context 'requesting disabled badge' do
      it 'returns a b&w large image from the country name' do
        expect(country.disabled_image).to eql('64/italy_bw.png')
      end
    end
  end

  describe 'validation' do
    it 'requires a name' do
      country.name = nil
      expect(country).to be_invalid
    end
    it 'requires a unique name' do
      create(:country, name: 'Unique')
      duplicate = build(:country, name: 'Unique')
      expect(duplicate).to be_invalid
    end
  end
end
