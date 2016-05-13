require 'rails_helper'

RSpec.describe AdminData, type: :model do
  let(:event) { create :event, :with_countries }

  subject(:data) { described_class.new(year) }

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
        expect(subject.count).to eq 3
      end

      it 'returns a country name' do
        expect(subject.first[0]).to eq event.participating_countries.first.country.name
      end

      describe 'returns an array of score data' do
        subject { countries.first[1] }

        it { is_expected.to be_a Array }

        it 'has five data points' do
          expect(subject.count).to eq 5
        end
      end
    end
  end
end
