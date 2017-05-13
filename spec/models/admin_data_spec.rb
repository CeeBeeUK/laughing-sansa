require 'rails_helper'

RSpec.describe AdminData, type: :model do
  subject(:data) { described_class.new(year) }

  let(:event) { create :event, :with_countries }

  context 'when initialised with a year' do
    let(:year) { event.year }

    it { is_expected.to be_a described_class }

    describe '#name' do
      subject { data.name }

      it { is_expected.to eq event.display_name }
    end

    describe '#host_flag' do
      subject { data.host_flag }

      it { is_expected.to eq event.country.xl_image }
    end

    describe '#countries' do
      subject(:countries) { data.countries }

      it 'returns a collection of countries in the event' do
        expect(countries.count).to eq 3
      end

      it 'returns a country name' do
        expect(countries.first[0]).to eq "#{event.participating_countries.first.country.name} (test)"
      end

      describe 'returns an array of score data' do
        subject(:country_count) { countries.first[1] }

        it { is_expected.to be_a Array }

        it 'has five data points' do
          expect(country_count.count).to eq 5
        end
      end
    end
  end
end
