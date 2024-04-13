require "rails_helper"

RSpec.describe StatusController, :clamav do
  describe "#ping" do
    context "when environment variables set" do
      let(:expected_json) do
        {
          "build_date" => "20150721",
          "build_tag" => "test",
        }
      end

      before do
        ENV['BUILD_DATE']       = '20150721'
        ENV['BUILD_TAG']        = 'test'

        get("/ping")
      end

      it "returns JSON with app information" do
        expect(response.parsed_body).to eq(expected_json)
      end
    end

    context "when environment variables not set" do
      before do
        ENV['BUILD_DATE']       = nil
        ENV['BUILD_TAG']        = nil

        get "/ping"
      end

      it 'returns "Not Available"' do
        expect(response.parsed_body.values).to be_all("Not Available")
      end
    end
  end
end
